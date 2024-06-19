import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';

part 'update_location_state.dart';

/// A BLoC responsible for handling earner location login functionality.
class UpdateLocationBloc extends Cubit<UpdateLocationState> {
  UpdateLocationBloc() : super(UpdateLocationInitial());
  bool showNearWidget = false;

  /// toggle Add Nearby Famous Shop/Mall/Landmark  widget
  void toggleWidget() {
    final cast = state;
    showNearWidget =!showNearWidget;
    emit(UpdateLocationLoading());
    emit(UpdateLocationInitial());
    emit(cast);
  }

  /// update user location process.
  Future<void> updateUserLocation(FormData formData) async {
    try {
      emit(UpdateLocationLoading());
      final response = await getAuthRepo.updateUserLocation(formData);
      if (response.status == RepoResponseStatus.success1 ||
          response.status == RepoResponseStatus.success) {
        emit(UpdateLocationSuccess(response.response));
        emit(UpdateLocationLoaded(response.response));
      } else {
        emit(UpdateLocationError(response.message ?? someWentWrong));
      }
    } catch (e, t) {
      emit(UpdateLocationError(e.toString()));
      errorLog("updateUserLocation: ${e.toString() + t.toString()}");
    }
  }
}