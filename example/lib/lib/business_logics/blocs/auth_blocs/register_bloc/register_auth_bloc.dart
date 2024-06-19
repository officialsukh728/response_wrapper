import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';

part 'register_auth_state.dart';

/// Enum representing the role constants for registration.
enum RegisterRoleConst {
  EARNER,
  ADVERTISER,
}

/// A BLoC responsible for handling the registration authentication process.
class RegisterAuthBloc extends Cubit<RegisterAuthState> {
  RegisterAuthBloc() : super(RegisterAuthInitial());

  /// Rebuilds the UI by emitting loading and initial states.
  void rebuildUi() {
    emit(ResisterAuthLoading());
    emit(RegisterAuthInitial());
  }

  /// Initiates the registration authentication process with the provided form data.
  ///
  /// This method sends the form data to the authentication repository and handles the response accordingly.
  ///
  /// Parameters:
  /// - [formData]: The form data containing user registration information.
  ///
  /// Returns:
  /// - None.
  FutureOr<void> resisterAuth(FormData formData) async {
    try {
      hideAppKeyboard;
      emit(ResisterAuthLoading());
      final response = await getAuthRepo.register(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(ResisterAuthLoadedSuccess(
          response.response,
          listener: true,
        ));
        emit(ResisterAuthLoaded(
          registerModel: response.response,
          formData: formData,
        ));
      } else {
        emit(ResisterAuthError(response.message ?? someWentWrong));
      }
    } catch (e, t) {
      emit(ResisterAuthError(e.toString()));
      errorLog(e.toString() + t.toString(), fun: '_onResisterAuthEvent');
    }
  }
}
