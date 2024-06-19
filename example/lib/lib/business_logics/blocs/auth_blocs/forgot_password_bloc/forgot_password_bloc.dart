import 'dart:async';

import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'forgot_password_state.dart';

/// Bloc responsible for handling forgot password functionality.
class ForgotPasswordBloc extends Cubit<ForgotPasswordState> {
  /// Initializes the [ForgotPasswordBloc] with initial state.
  ForgotPasswordBloc() : super(ForgotPasswordInitial());

  /// Sends a forgot password request with the provided [email].
  ///
  /// Parameters:
  /// - [email]: The email address for which forgot password request is made.
  /// - [listener]: Indicates whether to listen for changes in the state.
  Future<void> forgot({
    required String email,
    required String user_role,
    bool listener = true,
  }) async {
    try {
      emit(ForgotPasswordSendLoading());
      final formData = FormData.fromMap({'email': email,"user_role":user_role});
      final response = await getAuthRepo.forgot(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(ForgotPasswordSendSuccess(
          listener: listener,
          model: response.response,
        ));
        emit(ForgotPasswordLoaded(response.response));
      } else {
        emit(ForgotPasswordError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(ForgotPasswordError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "forgot");
    }
  }

  /// Verifies the provided [otp] for resetting the password for the given [userId].
  ///
  /// Parameters:
  /// - [otp]: The one-time password (OTP) to be verified.
  /// - [userId]: The user ID for whom the password reset is requested.
  Future<void> forgotPasswordVerify({
    required String otp,
    required String userId,
  }) async {
    try {
      emit(ForgotPasswordVerifyLoading());
      final formData = FormData.fromMap({
        'verify_otp': otp,
        'userId': userId,
        'deviceToken': await getFcmToken(),
        'deviceType': AppEndPoint.deviceType,
      });
      final response = await getAuthRepo.forgotPasswordVerify(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(ForgotPasswordVerifySuccess(response.response));
        emit(ForgotPasswordLoaded(response.response));
      } else {
        emit(ForgotPasswordError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(ForgotPasswordError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "forgot");
    }
  }
}
