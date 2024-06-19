import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keychain/flutter_keychain.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/blocs/location_cubit/location_cubit.dart';
import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/business_logics/service/prefers_utility.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/dashboard_count_model.dart';
import 'package:sample/models/profile_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/common/print_log.dart';

/// Abstract class defining methods for authentication repository.
abstract class AuthRepo {

  /// Logs in the user using provided form data.
  ///
  /// Makes an HTTP POST request to the login endpoint with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> login(FormData formData);

  /// Logs in the user using Google authentication.
  ///
  /// Initiates Google sign-in, retrieves user data, creates authentication credentials,
  /// and sends a request to the server with the obtained data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> googleLogin(FormData formData);

  /// Logs in the user using Apple authentication.
  ///
  /// Retrieves Apple ID credentials, processes the data, and sends a request to the server.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> appleLogin(FormData formData);

  /// Logs out the user.
  ///
  /// Sends a POST request to the logout endpoint with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> logout(FormData formData);

  /// Deletes the user account.
  ///
  /// Sends a POST request to the delete account endpoint with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> deleteAccount(FormData formData);

  /// Registers a new user using provided form data.
  ///
  /// Sends a POST request to the register endpoint with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> register(FormData formData);

  /// Retrieves the user's profile data.
  ///
  /// Sends a GET request to retrieve the user profile data.
  /// Returns a [ResponseWrapper] containing the user's profile data.
  Future<ResponseWrapper> getProfile(FormData formData);
  Future<ResponseWrapper> getEarnerDashboard(FormData formData);
  Future<ResponseWrapper> getAdvertiserDashboard(FormData formData);

  /// Sends a forgot password request using provided form data.
  ///
  /// Sends a POST request to the forgot password endpoint with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> forgot(FormData formData);

  /// Uploads an image using provided form data.
  ///
  /// Sends a POST request to upload an image with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> uploadImage(FormData formData);

  /// Verifies the forgot password request using provided form data.
  ///
  /// Sends a POST request to verify the forgot password request with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> forgotPasswordVerify(FormData formData);

  /// Creates a new password using provided form data.
  ///
  /// Sends a POST request to create a new password with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> createNewPassword(FormData formData);

  /// Edits the user's profile using provided form data.
  ///
  /// Sends a POST request to edit the user's profile with the provided form data.
  /// Returns a [ResponseWrapper] containing the result of the operation.
  Future<ResponseWrapper> editProfile(FormData formData);
  Future<ResponseWrapper> updateUserLocation(FormData formData);
  Future<ResponseWrapper> withdrawAmount(FormData formData);

  /// Retrieves privacy policy information from the provided endpoint.
  ///
  /// Sends a GET request to retrieve privacy policy information from the provided endpoint.
  /// Returns a [ResponseWrapper] containing the privacy policy data.
  Future<ResponseWrapper> privacyPolicy(String endPoint);
}

class AuthRepoImp extends AuthRepo {
  final showOtp = false;
  @override
  Future<ResponseWrapper> appleLogin(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Fetch data for apple login
      final data = await appleLoginMap();

      /// Check if data is null
      if (data == null) {
        /// Log error if data is null
        errorLog("null", fun: "appleLogin");
        return getFailedResponseWrapper(someWentWrong);
      }

      /// Determine device type
      final deviceType = Platform.isIOS ? "ios" : "android";

      /// Get device token (assuming fcmToken is a method that retrieves the device token)
      final deviceToken = await getFcmToken();
      /// Get location data (assuming locationState is a state management object holding location data)
      LocationState? locationState;
      if (globalBuildContextExits && globalBuildContext.mounted) {
        locationState = globalBuildContext.read<LocationCubit>().state;
      }

      /// Create formData object
      var formData = FormData.fromMap({
        'deviceType': deviceType,
        'deviceToken': deviceToken,
        'address': locationState?.address ?? 'N/A',
        "latitude": locationState?.position?.latitude ?? 0,
        "longitude": locationState?.position?.longitude ?? 0,
        if (globalBuildContextExits && globalBuildContext.mounted)
          "user_role": globalBuildContext.read<ChooseUserToggleBloc>().state.name,
      }..addAll(data));

      /// Make HTTP POST request
      final response = await getHttpService.post(
        endPoint: AppEndPoint.appleLogin,
        data: json.encode(
          Map.fromEntries(formData.fields),
        ),
      );

      /// Check response status code
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Save token and user role (assuming these methods save relevant data)
        await saveToken(model);
        await saveUserRole(model);

        /// Show a snackbar with the OTP if available, otherwise show the message
        showSnackBar(
            message: (showOtp) ? model.otp.toString() : model.message,
            success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return failed response
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log error if an exception occurs
      errorLog(e.toString() + t.toString(), fun: 'appleLogin');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> googleLogin(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Sign in with Google
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      /// Sign out from Google (optional, depending on your requirements)
      GoogleSignIn().signOut();

      /// Check if Google sign-in was successful
      if (googleSignInAccount != null) {
        /// Get Google authentication credentials
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        /// Create authentication credential for Firebase
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        /// Sign in to Firebase with the authentication credential
        UserCredential credential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

        /// Extract user data
        final name = credential.user?.displayName ?? "";
        final email = credential.user?.email ?? "";
        final googleId = credential.user?.uid ?? "";
        final googleToken = googleSignInAuthentication.accessToken;

        /// Determine device type
        final deviceType = Platform.isIOS ? "ios" : "android";

        /// Get device token (assuming getFcmToken() is a method that retrieves the device token)
        final deviceToken = await getFcmToken();
        /// Get location data (assuming locationState is a state management object holding location data)
        LocationState? locationState;
        if (globalBuildContextExits && globalBuildContext.mounted) {
          locationState = globalBuildContext.read<LocationCubit>().state;
        }

        /// Create form data
        var formData = FormData.fromMap({
          'name': name,
          'email': email,
          'googleId': googleId,
          'deviceType': deviceType,
          'deviceToken': deviceToken,
          'googleToken': googleToken,
          'address': locationState?.address ?? 'N/A',
          "latitude": locationState?.position?.latitude ?? 0,
          "longitude": locationState?.position?.longitude ?? 0,
          if (globalBuildContextExits && globalBuildContext.mounted)
            "user_role": globalBuildContext.read<ChooseUserToggleBloc>().state.name,
        });

        /// Send request to server
        final response = await getHttpService.post(
          endPoint: AppEndPoint.googleLogin,
          data: json.encode(
            Map.fromEntries(formData.fields),
          ),
        );

        /// Check response status
        if (response.statusCode == RepoResponseStatus.success ||
            response.statusCode == RepoResponseStatus.success1) {
          /// Parse the response data into a CommonAuthModel
          final model = CommonAuthModel.fromJson(response.data);

          /// Save token and user role (assuming these methods save relevant data)
          await saveToken(model);
          await saveUserRole(model);

          /// Show a snackbar with the OTP if available, otherwise show the message
          showSnackBar(
              message: (showOtp) ? model.otp.toString() : model.message,
              success: true);

          /// Return a success response
          return getSuccessResponseWrapper(model);
        } else {
          /// Return failed response
          return getFailedResponseWrapper(response.statusMessage);
        }
      } else {
        /// Google sign-in was not successful
        return getFailedResponseWrapper(someWentWrong);
      }
    } catch (e, t) {
      /// Error occurred during Google login process
      errorLog(e.toString() + t.toString(), fun: 'googleLogin');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> privacyPolicy(String endPoint) async {
    hideAppKeyboard;
    try {
      /// Make a GET request to the specified endpoint
      final response = await getHttpService.get(endPoint: endPoint);

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        return getSuccessResponseWrapper(
            CommonAuthModel.fromJson(response.data ?? {}));
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'privacyPolicy');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> createNewPassword(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to create a new password
      final response = await getHttpService.post(
        endPoint: AppEndPoint.createNewPassword,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Save token and user role (assuming these methods save relevant data)
        await saveToken(model);
        await saveUserRole(model);

        /// Show a snackbar with a success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'login');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> forgot(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the forgot password endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.forgot,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Show a snackbar with the OTP if available, otherwise show the message
        showSnackBar(
            message: (showOtp) ? model.otp.toString() : model.message,
            success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'login');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> editProfile(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the edit profile endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.editProfile,
        data:formData,
        // data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'editProfile');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> uploadImage(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the upload image endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.uploadImage,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'login');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> forgotPasswordVerify(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the forgot password verify endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.forgotPasswordVerify,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'forgotPasswordVerify');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> getProfile(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a GET request to retrieve the user profile
      final response = await getHttpService.get(
        endPoint: AppEndPoint.getUserProfile,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a ProfileModel
        final model = ProfileModel.fromJson(response.data);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'getProfile');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> getEarnerDashboard(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a GET request to retrieve the user profile
      final response = await getHttpService.get(
        endPoint: AppEndPoint.getEarnerDashboard,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a ProfileModel
        final model = EarnerDashboardCountModel.fromJson(response.data);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'getProfile');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> getAdvertiserDashboard(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a GET request to retrieve the user profile
      final response = await getHttpService.get(
        endPoint: AppEndPoint.getAdvertiserDashboard,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a ProfileModel
        final model = AdvertiserDashboardCountModel.fromJson(response.data);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'getProfile');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> login(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the login endpoint
      /// Get location data (assuming locationState is a state management object holding location data)
      LocationState? locationState;
      if (globalBuildContextExits && globalBuildContext.mounted) {
        locationState = globalBuildContext.read<LocationCubit>().state;
      }

      final response = await getHttpService.post(
        endPoint: AppEndPoint.login,
        data: jsonEncode(Map<String,dynamic>.fromEntries(formData.fields)..addAll({
          'address': locationState?.address ?? 'N/A',
          "latitude": locationState?.position?.latitude ?? 0,
          "longitude": locationState?.position?.longitude ?? 0,
        })),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Save token and user role (assuming these methods save relevant data)
        await saveToken(model);
        await saveUserRole(model);

        /// Show a snackbar with the OTP if available, otherwise show the message
        showSnackBar(
            message: (showOtp) ? model.otp.toString() : model.message,
            success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'login');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> logout(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the logout endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.logout,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data ?? {});

        /// Remove token (assuming this method removes the token)
        await removeToken();

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'logout');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> withdrawAmount(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the logout endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.withdrawAmount,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data ?? {});

        /// Remove token (assuming this method removes the token)
        await removeToken();

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'logout');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> deleteAccount(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the delete account endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.deleteAccount,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data ?? {});

        /// Remove token (assuming this method removes the token)
        await removeToken();

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'deleteAccount');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> register(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the register endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.register,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Save token and user role (assuming these methods save relevant data)
        await saveToken(model);
        await saveUserRole(model);

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'register');
      return getFailedResponseWrapper(e);
    }
  }
  @override
  Future<ResponseWrapper> updateUserLocation(FormData formData) async {
    hideAppKeyboard;
    try {
      /// Send a POST request to the register endpoint
      final response = await getHttpService.post(
        endPoint: AppEndPoint.updateUserLocation,
        data: json.encode(Map.fromEntries(formData.fields)),
      );

      /// Check if the response status indicates success
      if (response.statusCode == RepoResponseStatus.success ||
          response.statusCode == RepoResponseStatus.success1) {
        /// Parse the response data into a CommonAuthModel
        final model = CommonAuthModel.fromJson(response.data);

        /// Save token and user role (assuming these methods save relevant data)
        await saveToken(model);
        await saveUserRole(model);

        /// Show a snackbar with the success message
        showSnackBar(message: model.message, success: true);

        /// Return a success response
        return getSuccessResponseWrapper(model);
      } else {
        /// Return a failed response if the status code is not success
        return getFailedResponseWrapper(response.statusMessage);
      }
    } catch (e, t) {
      /// Log any errors that occur during the process
      errorLog(e.toString() + t.toString(), fun: 'register');
      return getFailedResponseWrapper(e);
    }
  }
  Future<void> saveToken(CommonAuthModel model) async {
    hideAppKeyboard;
    /// Check if the authentication token is present in the model
    if (model.token == null) return;

    /// Save the token into the local storage using a specific key
    await LocalStorage.instance.setString(
      key: PrefConstants.userToken,
      value: model.token ?? "",
    );
  }
  Future<void> saveUserRole(CommonAuthModel model) async {
    hideAppKeyboard;
    /// Check if the user role is present in the model
    if (model.userRole == null) return;

    /// Save the user role into the local storage using a specific key
    await LocalStorage.instance.setString(
      key: PrefConstants.userRole,
      value: "${model.userRole ?? "1"}",
    );
  }
  Future<void> removeToken() async {
    hideAppKeyboard;
    /// Remove the authentication token from the local storage using its key
    await LocalStorage.instance.removeOnly(PrefConstants.userToken);
  }
}
Future<Map<String, dynamic>?> appleLoginMap() async {
  hideAppKeyboard;
  try {
    String appleEmail = "";
    String fullName = "";
    String appleId = "";

    /// Retrieve Apple ID credentials
    AuthorizationCredentialAppleID credential =
    await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    /// Log Apple ID credential information
    infoLog(credential.authorizationCode, fun: "authorizationCode");
    infoLog(credential.identityToken, fun: "identityToken");
    infoLog(credential.userIdentifier, fun: "userIdentifier");

    /// Check if email is available
    if (credential.email == null || credential.email == '') {
      /// If email is not available, attempt to retrieve it from local storage
      var value = await FlutterKeychain.get(key: "userData");
      if (value != null) {
        /// Parse email, full name, and Apple ID from the stored value
        appleEmail = value.split(" ").first;
        if (value.split(" ").length > 1) {
          appleId = value.split(" ").last;
          fullName = value.replaceAll(appleEmail, "").replaceAll(appleId, "");
        }
      }
    } else {
      /// If email is available, store it in local storage
      await FlutterKeychain.put(
        key: "userData",
        value:
        "${credential.email} ${credential.givenName} ${credential.familyName} ${credential.userIdentifier}",
      );
      /// Set email, full name, and Apple ID from the credential
      appleEmail = credential.email ?? "";
      fullName = "${credential.givenName} ${credential.familyName}";
      appleId = credential.userIdentifier ?? "";
    }

    /// Return a map containing relevant information for login
    return {
      if (appleEmail.isNotEmpty) "email": appleEmail,
      if (fullName.isNotEmpty) "name": fullName,
      if (appleId.isNotEmpty) "appleId": appleId,
      if (credential.identityToken != null)
        "appleToken": credential.identityToken,
    };
  } catch (e, t) {
    /// Log any errors that occur during the process
    errorLog(e.toString() + t.toString(), fun: 'appleLogin');
    return null;
  }
}
