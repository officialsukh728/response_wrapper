import 'dart:async';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/app_urls.dart';

part 'privacy_policy_state.dart';

void getPrivacyPolicyBloc(BuildContext context) {
  context.read<PrivacyPolicyBloc>().getAboutUs();
  context.read<PrivacyPolicyBloc>().getTermsOfUse();
  context.read<PrivacyPolicyBloc>().getPrivacyPolicy();
}

class PrivacyPolicyBloc extends Cubit<PrivacyPolicyState> {
  PrivacyPolicyBloc() : super(const PrivacyPolicyState()){
    // getAboutUs();
    // getTermsOfUse();
    // getPrivacyPolicy();
  }

  Future<void> getPrivacyPolicy() async {
    try {
      emit(state.copyWith(loadingPrivacyPolicy: true));
      final response =
          await getAuthRepo.privacyPolicy(AppEndPoint.privacyPolicy);
      if (response.status == RepoResponseStatus.success ||
          response.status == RepoResponseStatus.success1) {
        emit(state.copyWith(
          loadingPrivacyPolicy: false,
          modelPrivacyPolicy: response.response,
        ));
      } else {
        emit(state.copyWith(loadingPrivacyPolicy: false));
      }
    } catch (e, s) {
      emit(state.copyWith(loadingPrivacyPolicy: false));
      errorLog(e.toString() + s.toString(), fun: "getPrivacyPolicyBloc");
    }
  }

  Future<void> getAboutUs() async {
    try {
      emit(state.copyWith(loadingAboutUs: true));
      final response =
      await getAuthRepo.privacyPolicy(AppEndPoint.aboutUs);
      if (response.status == RepoResponseStatus.success ||
          response.status == RepoResponseStatus.success1) {
        emit(state.copyWith(
          loadingAboutUs: false,
          modelAboutUs: response.response,
        ));
      } else {
        emit(state.copyWith(loadingAboutUs: false));
      }
    } catch (e, s) {
      emit(state.copyWith(loadingAboutUs: false));
      errorLog(e.toString() + s.toString(), fun: "getAboutUs");
    }
  }

  Future<void> getTermsOfUse() async {
    try {
      emit(state.copyWith(loadingTermsOfUse: true));
      final response =
      await getAuthRepo.privacyPolicy(AppEndPoint.termsOfUse);
      if (response.status == RepoResponseStatus.success ||
          response.status == RepoResponseStatus.success1) {
        emit(state.copyWith(
          loadingTermsOfUse: false,
          modelTermsOfUse: response.response,
        ));
      } else {
        emit(state.copyWith(loadingTermsOfUse: false));
      }
    } catch (e, s) {
      emit(state.copyWith(loadingTermsOfUse: false));
      errorLog(e.toString() + s.toString(), fun: "getTermsOfUse");
    }
  }
}
