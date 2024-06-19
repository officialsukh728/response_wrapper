import 'package:flutter/material.dart'; // Flutter framework
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Screen utilities
import 'package:sample/main.dart';
import 'package:sample/screens/splash_module/splash_screen.dart'; // Splash screen
import 'package:sample/utils/app_multi_provider.dart'; // Multi-provider utility
import 'package:sample/utils/common/app_config.dart'; // App configuration
import 'package:sample/utils/theme/app_theme.dart';


/// Main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /// Builds the main application widget.
  @override
  Widget build(BuildContext context) {
    /// Initialize app configuration
    AppConfig.init(context);

    /// Initialize screen utilities
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) {
        /// Multi-provider for app state management
        return AppMultiProvider(
          child: MaterialApp(
            /// Application title
            title: 'sample',

            /// Light theme
            theme: getAppThemeData,

            /// Dark theme
            darkTheme: getAppThemeData,

            /// Theme mode
            themeMode: ThemeMode.light,

            /// Disable debug banner
            debugShowCheckedModeBanner: false,

            /// Navigator key
            navigatorKey: AppConfig.materialKey,

            /// Initial screen
            home: const SplashScreen(),
            //home: Platform.isAndroid?ProfileScreen(profileModel: ProfileModel(),): const SplashScreen(),
            builder: (context, child) {
              /// Media query for text scale factor
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child ?? const SizedBox(),
              );
            },
          ),
        );
      },
    );
  }
}
