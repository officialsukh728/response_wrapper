import 'dart:async';
import 'dart:io';

import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/models/common_auth_model.dart';
import 'package:sample/models/response_wrapper.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'upload_image_state.dart';

class UploadImageBloc extends Cubit<UploadImageState> {
  UploadImageBloc() : super(UploadImageInitial());

  Future<void> uploadImage(File image) async {
    try {
      final FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split("/").last,
        )
      });
      emit(UploadImageLoading());
      final response = await getAuthRepo.uploadImage(formData);
      if (response.status == RepoResponseStatus.success ||
          response.status == RepoResponseStatus.success1) {
        emit(UploadImageSuccess(response.response));
        emit(UploadImageLoaded(response.response));
      } else {
        emit(UploadImageError(response.message ?? someWentWrong));
      }
    } catch (e, s) {
      emit(UploadImageError(e.toString()));
      errorLog(e.toString() + s.toString(), fun: "uploadImage");
    }
  }
}
