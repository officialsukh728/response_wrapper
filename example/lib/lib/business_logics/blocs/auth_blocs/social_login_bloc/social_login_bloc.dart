import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/profile_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/app_snackbar.dart';
import 'package:sample/utils/common/print_log.dart';

part 'social_login_state.dart';

/// A BLoC responsible for handling social login functionality.
class SocialLoginBloc extends Cubit<SocialLoginState> {
  SocialLoginBloc() : super(SocialLoginInitial());

  /// Initiates Google login process.
  Future<void> googleLogin() async {
    try {
      emit(SocialGoogleLoginLoading());
      final response = await getAuthRepo.googleLogin(emptyFormData);
      if (response.status == RepoResponseStatus.success1 ||
          response.status == RepoResponseStatus.success) {
        emit(SocialLoginSuccess(response.response));
        emit(SocialLoginLoaded(response.response));
      } else {
        emit(SocialLoginError(response.message ?? someWentWrong));
      }
    } catch (e, t) {
      emit(SocialLoginError(e.toString()));
      errorLog("googleLogin${e.toString() + t.toString()}");
    }
  }

  /// Initiates Facebook login process.
  Future<void> facebookLogin() async {
    try {
      showSnackBar(message: "Coming Soon");
       return;
    } catch (e, t) {
      emit(SocialLoginError(e.toString()));
      errorLog("googleLogin${e.toString() + t.toString()}");
    }
  }

  /// Initiates Apple login process.
  Future<void> appleLogin() async {
    try {
      emit(SocialAppleLoginLoading());
      final response = await getAuthRepo.appleLogin(emptyFormData);
      if (response.status == RepoResponseStatus.success1 ||
          response.status == RepoResponseStatus.success) {
        emit(SocialLoginSuccess(response.response));
        emit(SocialLoginLoaded(response.response));
      } else {
        emit(SocialLoginError(response.message ?? someWentWrong));
      }
    } catch (e, t) {
      emit(SocialLoginError(e.toString()));
      errorLog("appleSingInException${e.toString() + t.toString()}");
    }
  }
}

/// Checks if Apple sign-in is supported on the current platform.
Future<bool> isAppleSignInSupported() async {
  if (!Platform.isIOS) return false;
  return await SignInWithApple.isAvailable();
}
