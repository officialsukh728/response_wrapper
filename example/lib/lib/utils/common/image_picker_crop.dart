import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/common/permission_denied_dialogs.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> getAnyPermission({
  required BuildContext context,
  required Permission permissionType,
  required void Function() deniedDialog,
}) async {
  await permissionType.request();
  final status = await permissionType.status;
  bool isGranted = await permissionType.isGranted;
  final isLimitedIosPhotos =
      await isIOS14OrAboveAndPhotosPermission(permissionType);
  infoLog(
      " isGranted => $isGranted - isLimitedIosPhotos =>$isLimitedIosPhotos - status => $status",
      fun: permissionType);
  if (isGranted || isLimitedIosPhotos) return true;
  deniedDialog();
  return false;
}

Future<bool> isIOS14OrAboveAndPhotosPermission(
  Permission permissionType,
) async {
  if (!Platform.isIOS || permissionType != Permission.photos) return false;
  bool isLimited = await permissionType.isLimited;
  infoLog(isLimited, fun: '$permissionType isLimited');
  if (!isLimited) return false;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  List<String> versionComponents = iosInfo.systemVersion.split('.');
  int majorVersion = int.tryParse(versionComponents[0]) ?? 0;
  int minorVersion = int.tryParse(versionComponents[1]) ?? 0;

  /// Check if the version is iOS 14 or above
  return (majorVersion >= 14 || (majorVersion == 14 && minorVersion >= 0));
}

Future<File?> getImageCropperPicker({bool imageFromCamera = true,bool cropImage = true}) async {
  try {
    final cameraPermission = await getAnyPermission(
      context: globalBuildContext,
      permissionType: imageFromCamera ? Permission.camera :Platform.isIOS? Permission.photos:Permission.mediaLibrary,
      deniedDialog: () => showCameraPermissionDialog(
        globalBuildContext,
        imageFromCamera: imageFromCamera,
      ),
    );
    if (!cameraPermission) return null;
    XFile? pickedFile = await ImagePicker().pickImage(
      imageQuality: 10,
      source: imageFromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile == null||!cropImage) return null;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: CropAspectRatioPreset.values,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Cropper",
          lockAspectRatio: false,
          toolbarWidgetColor: Colors.white,
          toolbarColor: AppColors.primaryColor,
          initAspectRatio: CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: "Cropper",
        ),
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return File(pickedFile.path);
    }
  } catch (e) {
    errorLog("error while picking image. ${e.toString()}");
  }
  return null;
}

Future<List<XFile>?> getMultipleImagePicker() async {
  try {
    final cameraPermission = await getAnyPermission(
      context: globalBuildContext,
      permissionType: Platform.isIOS? Permission.photos:Permission.mediaLibrary,
      deniedDialog: () => showCameraPermissionDialog(
        globalBuildContext,
        imageFromCamera: false,
      ),
    );
    if (!cameraPermission) return null;
    final pickedFile = await ImagePicker().pickMultiImage(
      imageQuality: 10,
    );
    return pickedFile;
  } catch (e) {
    errorLog("error while picking multiple image. ${e.toString()}");
  }
  return null;
}

Future<File?> getVideoPicker({bool imageFromCamera = true}) async {
  try {
    XFile? pickedFile = await ImagePicker().pickVideo(
      source: imageFromCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      printLog("No video is selected.");
    }
  } catch (e) {
    errorLog("Error while picking video. ${e.toString()}");
  }
  return null;
}

Future showImageOptionsBottomSheet(
  BuildContext context, {
  void Function()? openCamera,
  void Function()? openGallery,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                    if (openCamera == null) return;
                    openCamera();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                      ),
                      SizedBox(width: 8.w),
                     AppText(
                        'Upload from camera',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            25.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                    if (openGallery == null) return;
                    openGallery();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.image,
                      ),
                      SizedBox(width: 8.w),
                     AppText(
                        'Upload from gallery',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.heightBox,
          ],
        ),
      );
    },
  );
}
