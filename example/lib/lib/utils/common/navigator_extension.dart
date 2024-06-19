import 'package:sample/utils/common/print_log.dart'; // Logging utility
import 'package:flutter/material.dart'; // Flutter framework
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Screen utilities

/// Extension methods for navigation related functionalities on BuildContext.
extension AppNavigation on BuildContext {
  /// Navigates to a new screen and replaces the current screen.
  Future<dynamic> pushReplacement(Widget child,
      {PageRouteAnimation? pageRouteAnimation}) {
    return Navigator.pushReplacement(
      this,
      buildPageRoute(child: child, pageRouteAnimation: pageRouteAnimation),
    ).onError((error, stackTrace) => errorLog(
        error.toString() + stackTrace.toString(),
        fun: "pushReplacement"));
  }

  /// Navigates to a new screen.
  Future<dynamic> push(Widget child,
      {PageRouteAnimation? pageRouteAnimation}) {
    return Navigator.push(
      this,
      buildPageRoute(child: child, pageRouteAnimation: pageRouteAnimation),
    ).onError((error, stackTrace) =>
        errorLog(error.toString() + stackTrace.toString(), fun: "push"));
  }

  /// Navigates to a new screen and removes all previous screens from the navigation stack.
  Future<dynamic> pushAndRemoveUntil(Widget child,
      {PageRouteAnimation? pageRouteAnimation}) async {
    return await Navigator.of(this).pushAndRemoveUntil(
      buildPageRoute(child: child, pageRouteAnimation: pageRouteAnimation),
          (Route<dynamic> route) => false,
    );
  }

  /// Pops the current screen from the navigation stack.
  Future<dynamic> pop<T>([T? result]) async {
    if(Navigator.canPop(this)) {
      return Navigator.pop(this, result);
    }
  }
  /// Pops the current screen from the navigation stack.
  Future<dynamic> popUntil<T>([T? result]) async {
    return Navigator.of(this, rootNavigator: true).popUntil((route) => route.isFirst);
  }
}

/// Enum defining page route animation types.
enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

/// Builds a custom page route based on the specified animation type.
Route<T> buildPageRoute<T>({
  required Widget child,
  PageRouteAnimation? pageRouteAnimation,
}) {
  PageRouteAnimation? pageAnimation =
      pageRouteAnimation /*?? PageRouteAnimation.Scale*/;
  if (pageAnimation == PageRouteAnimation.Fade) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      transitionsBuilder: (c, anim, a2, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 1000),
    );
  } else if (pageAnimation == PageRouteAnimation.Rotate) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      transitionsBuilder: (c, anim, a2, child) =>
          RotationTransition(turns: ReverseAnimation(anim), child: child),
      transitionDuration: const Duration(milliseconds: 700),
    );
  } else if (pageAnimation == PageRouteAnimation.Scale) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      transitionsBuilder: (c, anim, a2, child) =>
          ScaleTransition(scale: anim, child: child),
      transitionDuration: const Duration(milliseconds: 700),
    );
  } else if (pageAnimation == PageRouteAnimation.Slide) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      transitionsBuilder: (c, anim, a2, child) => SlideTransition(
        position:
        Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
            .animate(anim),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  } else if (pageAnimation == PageRouteAnimation.SlideBottomTop) {
    return PageRouteBuilder(
      pageBuilder: (c, a1, a2) => child,
      transitionsBuilder: (c, anim, a2, child) => SlideTransition(
        position:
        Tween(begin: const Offset(0.0, 1.0), end: const Offset(0.0, 0.0))
            .animate(anim),
        child: child,
      ),
      transitionDuration: const Duration(milliseconds: 500),
    );
  } else {
    return MaterialPageRoute<T>(builder: (_) => child);
  }
}

/// Extension methods to manipulate strings.
extension StringCapitalCaseExtension on String {
  /// Converts the string to title case.
  String toTitleCase() {
    return split(RegExp(r'(?<=[a-z])(?=[A-Z])|_'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Converts the string to capital case.
  String toCapitalCase() {
    if (isEmpty) return this;
    final words = split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });
    return capitalizedWords.join(' ');
  }

  /// Capitalizes the first word of the string only.
  String toCapitalizeFirstWordOnly() {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }

  /// Capitalizes every first letter of each word in the string.
  String toCapitalizeEveryFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

/// Extension methods to convert numerical values to SizedBox.
extension DoubleToSizedBoxExtension on num {
  /// Creates a SizedBox with the specified height.
  SizedBox get heightBox => SizedBox(height: (this).h);

  /// Creates a SizedBox with the specified width.
  SizedBox get widthBox => SizedBox(width: (this).w);

  /// Creates a SizedBox with the specified height.
  SizedBox get yHeight => SizedBox(height: (this).h);

  /// Creates a SizedBox with the specified width.
  SizedBox get xWidth => SizedBox(width: (this).w);
}

/// Extension methods to add padding property to child widget.
extension WidgetPaddingX on Widget {
  /// Adds padding to all sides of the child.
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  /// Adds symmetric padding to the child.
  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
          padding:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  /// Adds padding to the child with different values for each side.
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  /// Adds zero padding to the child.
  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

/// Extension methods to add margin property to child widget.
extension WidgetMarginX on Widget {
  /// Adds margin to all sides of the child.
  Widget marginAll(double margin) =>
      Container(margin: EdgeInsets.all(margin), child: this);

  /// Adds symmetric margin to the child.
  Widget marginSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Container(
          margin:
          EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: this);

  /// Adds margin to the child with different values for each side.
  Widget marginOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Container(
          margin: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  /// Adds zero margin to the child.
  Widget get marginZero => Container(margin: EdgeInsets.zero, child: this);
}

/// Extension methods to insert child widgets inside a CustomScrollView.
extension WidgetSliverBoxX on Widget {
  /// Converts the child widget to a sliver and inserts it inside a CustomScrollView.
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}
