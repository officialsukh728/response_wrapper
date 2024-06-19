import 'dart:async'; // Asynchronous operations

import 'package:flutter/material.dart'; // Flutter framework
import 'package:sample/business_logics/service/prefers_utility.dart'; // Preferences utility
import 'package:sample/screens/auth_screens/auth_screen.dart'; // Authentication screen
import 'package:sample/screens/dashboard_screen/dashboard.dart'; // Dashboard screen
import 'package:sample/utils/common/AppColors.dart'; // App colors
import 'package:sample/utils/common/app_config.dart'; // App configuration
import 'package:sample/utils/common/navigator_extension.dart'; // Navigator extension
import 'package:sample/utils/common/print_log.dart'; // Logging utility

/// Splash screen widget.
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  /// Builds the splash screen UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Background color
      backgroundColor: AppColors.secondaryColor,
      body: FutureBuilder(
        /// Delay function for splash screen
        future: delayFunction(context),
        builder: (context, _) {
          return SizedBox(
            /// Set height to full screen height
            height: AppConfig.height,

            /// Set width to full screen width
            width: AppConfig.width,
            // child: Center(
            //   child: AppCommonImage(
            //     /// Image height
            //     height: AppConfig.height * 0.5,
            //     /// Image width
            //     width: AppConfig.width * 0.5,
            //     /// Image path
            //     imagePath: AppImagesPath.appSplash,
            //   ),
            // ),
          );
        },
      ),
    );
  }

  /// Delays screen transition for splash screen.
  Future<void> delayFunction(BuildContext context) async {
    /// Delay for 4 seconds
    await Future.delayed(const Duration(seconds: 4));

    /// Check if context is still mounted
    if (!context.mounted) return;

    /// Get user token from preferences
    final userToken = LocalStorage.instance.getString(PrefConstants.userToken);

    /// Log user token
    infoLog(userToken, fun: "userToken");

    /// Check if context is still mounted
    if (!context.mounted) return;
    context.pushAndRemoveUntil(
      /// Navigate based on user token
      // userToken == null ? const ChooseUserScreen() : const Dashboard(),
      userToken == null ? const Dashboard() : const Dashboard(),
    );
  }
}
