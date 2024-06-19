import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sample/business_logics/blocs/auth_blocs/profile_bloc/profile_bloc.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';

part 'create_new_password_state.dart';

/// BLoC responsible for creating a new password.
class CreateNewPasswordBloc extends Cubit<CreateNewPasswordState> {
  CreateNewPasswordBloc() : super(CreateNewPasswordInitial());

  /// Creates a new password for the user.
  ///
  /// Parameters:
  /// - [password]: The new password to set.
  /// - [conPassword]: The confirmation of the new password.
  /// - [oldPassword]: The old password for verification (optional).
  /// - [userId]: The user ID for whom the password is being updated.
  /// - [context]: The current build context.
  ///
  /// Returns:
  /// - None.
  Future<void> createNewPassword({
    required String password,
    required String conPassword,
    required String oldPassword,
    required String userId,
    required BuildContext context,
  }) async {
    try {
      final profileState = context.read<ProfileBloc>().state;
      if (userId.isEmpty && profileState is ProfileLoaded) {
        userId = profileState.profileModel.userData?.id.toString() ?? "";
      }
      emit(CreateNewPasswordLoading());
      final formData = FormData.fromMap({
        "userId": userId,
        'newPassword': password,
        'reenterPassword': conPassword,
        if (oldPassword.isNotEmpty) 'oldPassword': oldPassword,
      });
      final response = await getAuthRepo.createNewPassword(formData);
      if (response.status == RepoResponseStatus.success) {
        emit(CreateNewPasswordSuccess(response.response));
        emit(CreateNewPasswordLoaded(response.response));
      } else {
        emit(CreateNewPasswordError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(CreateNewPasswordError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "createNewPassword");
    }
  }
}
