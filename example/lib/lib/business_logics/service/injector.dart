import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sample/business_logics/repository/auth_repo.dart';
import 'package:sample/business_logics/repository/location_repo.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/business_logics/service/dio_services.dart';
import 'package:sample/business_logics/service/notification/firebase_notifcation.dart';
import 'package:sample/business_logics/service/notification/local_notification_api.dart';
import 'package:sample/business_logics/service/prefers_utility.dart';
import 'package:sample/firebase_options.dart';

/// Application ID
/// E11A5393
/// Application Name
/// sample

/// Callback signature for the application's main runner.
typedef AppRunner = FutureOr<void> Function();

/// Class responsible for initializing the application and its dependencies.
class AppInjector {
  /// Initializes the application and its dependencies.
  static Future<void> init({
    required AppRunner appRunner,
  }) async {
    /// Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    /// Initialize Firebase with default options
    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform);

    /// Set preferred device orientations
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    /// Hide the app keyboard
    hideAppKeyboard;

    /// Initialize dependencies
    await _initDependencies();

    /// Initialize notification service
    // NotificationService.init();

    /// Initialize local notification service
    // LocalNotificationService.init();

    /// Initialize local storage
    await LocalStorage.instance.initialize();

    /// Initialize date formatting
    await initializeDateFormatting();

    /// Hide the app keyboard again
    hideAppKeyboard;
    Stripe.publishableKey = AppStripeKeys.publishableKey;
    /// Run the application
    appRunner();
  }

  /// Initializes the application dependencies.
  static Future<void> _initDependencies() async {
    /// Ensure all dependencies are ready
    await GetIt.I.allReady();
    /// Register singleton for navigator key
    GetIt.I.registerSingleton<GlobalKey<NavigatorState>>(
        GlobalKey<NavigatorState>());

    /// Register singleton for HTTP service
    GetIt.I.registerSingleton<HttpService>(HttpService());

    /// Register singleton for authentication repository
    GetIt.I.registerSingleton<AuthRepo>(AuthRepoImp());

    /// Register singleton for location repository
    GetIt.I.registerSingleton<LocationRepo>(LocationRepoImp());

  }
}
class AppStripeKeys {
  static String publishableKey =
      'pk_test_51P6XIWSHTUjCJ3dHOXYCWGQdQn03dbEJmH2pNhnIvkiWw5x8b662jhRFBVgV5pf5TSfPlC2HdnIsBxUUYGUoZMM200f3zw61Yy';
  static String secretKey =
      'sk_test_51P6XIWSHTUjCJ3dHBsdsPnEcPWPBlJNp3xL0aizg5m6HKN37N35gszugkZbf7DV6aegiwIhypH4x64rCuUvexwrc00XDRRWVs8';
}