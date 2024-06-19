import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Class to manage application configuration.
class AppConfig {
  /// The height of the screen.
  static double height = 0.0;

  /// The width of the screen.
  static double width = 0.0;

  /// Initializes the configuration with the provided [BuildContext].
  static void init(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
  }

  /// GlobalKey for managing the material navigator state.
  static GlobalKey<NavigatorState> materialKey =
  GetIt.I.get<GlobalKey<NavigatorState>>();
}

/// Retrieves the global [BuildContext].
BuildContext get globalBuildContext => AppConfig.materialKey.currentContext!;

/// Checks if the global [BuildContext] exists.
bool get globalBuildContextExits =>
    AppConfig.materialKey.currentContext != null;
