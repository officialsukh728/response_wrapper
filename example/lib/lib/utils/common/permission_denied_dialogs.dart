
import 'dart:io';

import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/custom_dialog.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/common/print_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool?> getAnyPermission({
  required BuildContext context,
  required Permission permissionType,
  required void Function() deniedDialog,
}) async {
  await permissionType.request();
  bool isPermanentlyDenied = await permissionType.isPermanentlyDenied;
  errorLog(isPermanentlyDenied, fun: 'isPermanentlyDenied');
  bool isDenied = await permissionType.isDenied;
  errorLog(isDenied, fun: 'isDenied');
  bool isGranted = await permissionType.isGranted;
  printLog(isGranted, fun: 'isGranted');
  if (Platform.isAndroid && isPermanentlyDenied) {
    deniedDialog();
  }
  if (Platform.isIOS && (isPermanentlyDenied || isDenied)) {
    deniedDialog();
  }
  if (isGranted && context.mounted) {
    return true;
  }
  final status = await permissionType.status;
  errorLog(status, fun: '$permissionType==>>>');
  return null;
}

void showCameraPermissionDialog(
  BuildContext context, {
  required bool imageFromCamera,
}) {
  String subTitle =
      "Please give us ${imageFromCamera ? 'camera' : 'photos'} permission to take pictures";
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CustomDialog(
          title: '${imageFromCamera ? "Camera" : "Photos"} Permission',
          subTitle: subTitle,
          cancelTitle: 'Not Now',
          button: AppCommonButton(
              context: context,
            width: AppConfig.width * 0.5,
            title: "Open Setting",
            onTap: () async {
              // if(context.mounted && Navigator.canPop(context)) context.pop();
              await openAppSettings();
            },
          ),
        );
      });
}

void showMicrophonePermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CustomDialog(
          title: 'Microphone Permission',
          titleFontSize: 25.sp,
          subTitle: "Please give us microphone permission to record video from your camera",
          cancelTitle: 'Not Now',
          button: AppCommonButton(
              context: context,
            title: "Open Setting",
            onTap: () async {
              if(context.mounted) context.pop();
              await openAppSettings();
            },
          ),
        );
      });
}
void showPhotoPermissionDialog(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CustomDialog(
          title: 'Photos Permission',
          titleFontSize: 25.sp,
          subTitle: "Please give us photos permission to take photo from gallery",
          cancelTitle: 'Not Now',
          button: AppCommonButton(
              context: context,
            title: "Open Setting",
            onTap: () async {
              if(context.mounted) context.pop();
              await openAppSettings();
            },
          ),
        );
      });
}
// void fullScreenLoading(BuildContext context){
//   showDialog(context: context, builder: (_){
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Container(
//             height: 167.h,
//             margin: EdgeInsets.only(top: 10.h),
//             width: MediaQuery.sizeOf(context).width,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(AppImages.backGroundCherry),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           45.yHeight,
//           Container(
//             height: 100.h,
//               width: 100.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10.r),
//                 color: AppColors.primaryColor.withOpacity(0.3)
//               ),
//               child: getCustomLoading(strokeWidth: 4)),
//          AppText('In Processing',style: Theme.of(context).textTheme.headlineMedium,),
//          AppText('Account creation is in progress.\nThank you for your patience',style: Theme.of(context).textTheme.bodyMedium,),
//           45.yHeight,
//           Container(
//             height: 280.h,
//             width: MediaQuery.sizeOf(context).width,
//             decoration: const BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage(AppImages.backGroundImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   });
// }
void showLocationPermissionDialog(
    BuildContext context,
    ) {
  String subTitle =
      "Please give us location permission to access your location.";
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return CustomDialog(
          title: "Location Permission",
          subTitle: subTitle,
          cancelTitle: 'Not Now',
          button: AppCommonButton(
            context: context,
            width: AppConfig.width * 0.5,
            title: "Open Setting",
            onTap: () async {
              await openAppSettings();
            },
          ),
        );
      });
}
