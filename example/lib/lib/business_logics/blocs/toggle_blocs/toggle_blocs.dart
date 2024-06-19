// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sample/business_logics/blocs/auth_blocs/register_bloc/register_auth_bloc.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_date_time_picker.dart';
import 'package:sample/utils/common/image_picker_crop.dart';
import 'package:sample/utils/common/navigator_extension.dart';

/// Function to disable all toggle blocs.
void disableToggleBlocs() {
  globalBuildContext.read<ShowPasswordToggleBloc>().add(true);
  globalBuildContext.read<ShowConPasswordToggleBloc>().add(true);
  globalBuildContext.read<ShowOldPasswordToggleBloc>().add(true);
}

/// Bloc for toggling visibility of the password field.
class ShowPasswordToggleBloc extends Bloc<bool, bool> {
  ShowPasswordToggleBloc() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

/// Bloc for toggling visibility of the old password field.
class ShowOldPasswordToggleBloc extends Bloc<bool, bool> {
  ShowOldPasswordToggleBloc() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

/// Bloc for toggling between user types.
class ChooseUserToggleBloc extends Bloc<RegisterRoleConst, RegisterRoleConst> {
  ChooseUserToggleBloc() : super(RegisterRoleConst.ADVERTISER) {
    on<RegisterRoleConst>((event, emit) => emit(event));
  }
}

/// Cubit for triggering rebuild when text field is changed.
class TextFieldOnChangedToggleBloc extends Cubit<int> {
  TextFieldOnChangedToggleBloc() : super(0);

  void rebuild() => emit(state + 1);
}
/// Cubit for triggering rebuild when text field is changed.
class ProgressOnChangedToggleBloc extends Cubit<num> {
  ProgressOnChangedToggleBloc() : super(0);

  void rebuild() => emit(state + 1);
}

/// Cubit for triggering rebuild when number picker value is changed.
class NumberPickerChangedToggleBloc extends Cubit<int> {
  NumberPickerChangedToggleBloc() : super(0);

  void rebuild() => emit(state + 1);
}

/// Cubit for managing the index of selected post image.
class PostImageIndexToggleBloc extends Cubit<int> {
  PostImageIndexToggleBloc() : super(0);

  void setImageIndex(int index) => emit(index);
}

/// Bloc for toggling the state of a checkbox.
class CheckBoxToggleBloc extends Bloc<bool, bool> {
  CheckBoxToggleBloc() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

/// Bloc for toggling visibility of the confirm password field.
class ShowConPasswordToggleBloc extends Bloc<bool, bool> {
  ShowConPasswordToggleBloc() : super(true) {
    on<bool>((event, emit) => emit(event));
  }
}

/// Cubit for opening date picker.
class OpenDatePickerBloc extends Cubit<String?> {
  OpenDatePickerBloc() : super(null);

  /// Function to open date picker and emit the selected date.
  Future<String?> onSelectDate(BuildContext context) async {
    final date = await openDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (date.isEmpty) return null;
    emit(null);
    emit(date);
    return date;
  }

  /// Function to open year picker and emit the selected year.
  Future<String?> onYearPicker(BuildContext context, {String? initYear}) async {
    DateTime initialDate;
    try {
      initialDate = (initYear != null && initYear.isNotEmpty)
          ? DateFormat('yyyy').parse(initYear)
          : DateTime.now();
    } catch (e) {
      initialDate = DateTime.now();
    }
    final date = await openYearPicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 100)),
    );
    if (date.isEmpty) return null;
    emit(null);
    emit(date);
    return date;
  }
  /// Function to open time picker and emit the selected time.
  Future<String?> onSelectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    final selectedDateTime =formatTimeOfDay(time);
    if (selectedDateTime.isEmpty) return null;
    emit(null);
    emit(selectedDateTime);
    return selectedDateTime;
  }
  /// Function to open time picker and emit the selected time.
  Future<String?> onSelectDuration(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 0, minute: 0),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child??0.yHeight,
        );
      },
    );
    if (time == null) return null;
    final selectedDateTime ='${time.hour}:${time.minute}';
    if (selectedDateTime.isEmpty||selectedDateTime == '0:0') {
      return null;
    }
    emit(null);
    final response = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    emit(response);
    return response;
  }
}

/// Cubit for selecting images and videos.
class ImageVideoSelectionBloc extends Cubit<int> {
  ImageVideoSelectionBloc() : super(0);

  /// Function to select an image.
  Future<File?> selectImage({
    bool imageFromCamera = true,
    bool cropImage = true,
  }) async {
    final image = await getImageCropperPicker(
      imageFromCamera: imageFromCamera,
    );
    emit(state + 1);
    return image;
  }

  /// Function to select a video.
  Future<File?> getVideoPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;
    emit(state + 1);
    return File(result.files.first.path ?? "");
  }

  /// Function to select multiple images.
  Future<List<XFile>?> selectMultipleImage() async {
    final image = await getMultipleImagePicker();
    emit(state + 1);
    return image;
  }

  void rebuild() => emit(state + 1);
}