import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/business_logics/service/app_urls.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Part file to hold the state for the LoginBloc
part 'login_state.dart';

/// Business logic component responsible for handling login functionality
class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginInitial());

  /// Method to initiate the login process
  Future<void> login({
    required GlobalKey<FormState> formKey,
    required TextEditingController passwordController,
    required TextEditingController emailController,
    required BuildContext context,
  }) async {
    try {
      /// Validate the form fields
      if (formKey.currentState?.validate() == false) return;

      /// Hide the keyboard
      hideAppKeyboard;

      /// Emit login loading state
      emit(LoginLoading());

      /// Create form data for login request
      final formData = FormData.fromMap({
        /// Add email field to the form data with the value from emailController
        'email': emailController.text,

        /// Add password field to the form data with the value from passwordController
        'password': passwordController.text,

        /// Add deviceType field to the form data with the value from AppEndPoint.deviceType
        'deviceType': AppEndPoint.deviceType,

        /// Determine the user role based on the state of ChooseUserToggleBloc and add it to the form data
        /// If the user is an earner, use RegisterRoleConst.Earner.index, otherwise use RegisterRoleConst.Advertiser.index
        "user_role": context.read<ChooseUserToggleBloc>().state.name,

        /// Add deviceToken field to the form data with the value obtained asynchronously from fcmToken
        'deviceToken': await getFcmToken(),
      });

      /// Send login request to the repository
      final response = await getAuthRepo.login(formData);

      /// Check the response status and emit corresponding states
      if (response.status == RepoResponseStatus.success) {
        emit(LoginLoadedSuccess(response.response));
        emit(LoginLoaded(response.response));
      } else {
        emit(LoginError(response.message ?? someWentWrong));
      }
    } catch (e, t) {
      /// Emit login error state in case of any exceptions
      emit(LoginError(e.toString()));
      errorLog(e.toString() + t.toString(), fun: "login");
    }
  }
}
