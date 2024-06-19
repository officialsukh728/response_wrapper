import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sample/utils/common/app_config.dart';

/// Shows a custom snack bar with a message.
///
/// This function displays a snack bar with the provided [message]. It also allows customization
/// such as specifying a [specialMessage], [widget], [backGroundColor], [success], [snackBarBehavior],
/// and [duration]. It utilizes the Fluttertoast package to show the snack bar as a toast message.
void showSnackBar({
  /// The message to display in the snack bar.
  required String? message,

  /// Additional message information.
  String? specialMessage,

  /// Custom widget to display in the snack bar.
  Widget? widget,

  /// Background color of the snack bar.
  Color? backGroundColor,

  /// Indicates if the snack bar represents a success message.
  bool success = false,

  /// Behavior of the snack bar.
  SnackBarBehavior? snackBarBehavior,

  /// Duration for which the snack bar is displayed.
  Duration duration = const Duration(seconds: 2),
}) {
  if (globalBuildContextExits &&
      message != null &&
      message.isNotEmpty &&
      !message.toLowerCase().contains("null")) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      fontSize: 14.sp,
      timeInSecForIosWeb: 5,
      textColor: Colors.white,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: success ? Colors.green : Colors.red,
    );
    // ScaffoldMessenger.of(globalBuildContext)
    //   ..clearSnackBars()
    //   ..showSnackBar(
    //     SnackBar(
    //       duration: duration,
    //       backgroundColor: success ? Colors.green : Colors.red,
    //       content: widget ??
    //          AppText(
    //             /*enumToString*/
    //             (message).toCapitalizeFirstWord(),
    //             style: TextStyle(
    //               fontSize: 14.sp,
    //               fontWeight: FontWeight.normal,
    //             ),
    //           ),
    //       behavior: SnackBarBehavior.floating,
    //     ),
    //   );
  }
}
