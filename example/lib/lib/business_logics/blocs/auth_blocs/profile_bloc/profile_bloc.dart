import 'dart:async';

import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/business_logics/service/prefers_utility.dart';
import 'package:sample/models/profile_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

void getProfileData(BuildContext context) {
  context.read<ProfileBloc>().getProfile();
}

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    /*if (LocalStorage.instance.getString(PrefConstants.userToken) != null) {
      getProfile();
    }*/
  }

  Future<void> getProfile() async {
    try {
      emit(ProfileLoading());
      final response = await getAuthRepo.getProfile(emptyFormData);
      if (response.status == RepoResponseStatus.success ||
          response.status == RepoResponseStatus.success1) {
        emit(ProfileLoadedSuccess(response.response));
        emit(ProfileLoaded(response.response));
      } else {
        emit(ProfileError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(ProfileError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "getProfile");
    }
  }
}