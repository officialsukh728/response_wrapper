import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';

part 'logout_auth_state.dart';

/// Bloc responsible for handling logout and account deletion actions.
class LogoutDeleteAuthBloc extends Cubit<LogoutDeleteAuthState> {
  /// Initializes the LogoutDeleteAuthBloc with the initial state.
  LogoutDeleteAuthBloc() : super(LogoutAuthInitial());

  /// Handles the logout action.
  Future<void> logout() async {
    try {
      hideAppKeyboard;
      emit(LogoutAuthLoading());
      final formData = FormData.fromMap({
        'deviceType': Platform.isAndroid ? 'android' : "ios",
        'deviceToken': await getFcmToken()
      });
      final response = await getAuthRepo.logout(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(LogoutAuthSuccess(response.response));
        emit(LogoutDeleteAuthLoaded(response.response));
      } else {
        emit(LogoutDeleteAuthError(
          response.message ?? "Something Went Wrong !",
        ));
      }
    } catch (e, s) {
      errorLog(e.toString() + s.toString());
    }
  }

  /// Handles the account deletion action.
  Future<void> delete(String password) async {
    try {
      hideAppKeyboard;
      emit(DeleteAuthLoading());
      final formData = FormData.fromMap({
        "password": password,
        'deviceToken': await getFcmToken(),
        'deviceType': Platform.isAndroid ? 'android' : "ios",
      });
      final response = await getAuthRepo.deleteAccount(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(DeleteAuthSuccess(response.response));
        emit(LogoutDeleteAuthLoaded(response.response));
      } else {
        emit(LogoutDeleteAuthError(
            response.message ?? "Something Went Wrong !"));
      }
    } catch (e, s) {
      errorLog(e.toString() + s.toString());
    }
  }
}
