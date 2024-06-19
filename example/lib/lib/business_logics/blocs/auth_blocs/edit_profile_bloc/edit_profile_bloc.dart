import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/app_date_time_picker.dart';
import 'package:sample/utils/common/image_picker_crop.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Cubit<EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial());

  Future<void> editProfile(FormData data) async {
    try {
      emit(EditProfileLoading());
      ResponseWrapper response = await getAuthRepo.editProfile(data);
      if (response.status == RepoResponseStatus.success) {
        emit(EditProfileLoadedSuccess(response.response));
        emit(EditProfileLoaded(response.response));
      } else {
        emit(EditProfileError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(EditProfileError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "editProfile");
    }
  }

  void imageOnTap({
    required BuildContext context,
    required TextEditingController imageController,
  }) async {
    showImageOptionsBottomSheet(
      context,
      openCamera: () async {
        final image = await getImageCropperPicker(imageFromCamera: true);
        if (image == null) return;
        imageController.text = image.path;
        emit(EditProfileOnImageLoading());
        emit(EditProfileInitial());
      },
      openGallery: () async {
        final image = await getImageCropperPicker(imageFromCamera: false);
        if (image == null) return;
        imageController.text = image.path;
        emit(EditProfileOnImageLoading());
        emit(EditProfileInitial());
      },
    );
  }

  void dobOnTap(
    BuildContext context, {
    required TextEditingController dobController,
  }) async {
    final date = await openDatePicker(context: context);
    if (date.isEmpty) return;
    dobController.text = date;
    emit(EditProfileOnDobLoading());
    emit(EditProfileInitial());
  }

  void rebuildUi() async {
    if (state is EditProfileLoading) return;
    emit(EditProfileInitial());
    emit(EditProfileOnRadioLoading());
    emit(EditProfileInitial());
  }
  void clear() async {
    emit(EditProfileInitial());
  }
}
