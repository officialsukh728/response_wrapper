import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/theme/app_theme.dart';

/// A common app bar widget used throughout the application.
class AppBarCommon extends StatelessWidget implements PreferredSizeWidget {
  /// [title] is the text to be displayed in the app bar.
  final String title;
  /// [titleWidget] is an optional widget to be displayed instead of text.
  final Widget? titleWidget;
  /// [centerTitle] determines whether the title should be centered.
  final bool centerTitle;
  /// [leading] determines whether to display the leading icon.
  final bool leading;
  /// [leadingWidget] is an optional widget to be displayed instead of the leading icon.
  final Widget? leadingWidget;
  final PreferredSizeWidget? bottomWidget;
  /// [actions] is a list of widgets to be displayed as actions on the app bar.
  final List<Widget>? actions;
  /// [fontSize] is the font size of the title.
  final double? fontSize;
  /// [fontWeight] is the font weight of the title.
  final FontWeight? fontWeight;
  /// [onPressed] is the callback function when the leading icon is pressed.
  final VoidCallback? onPressed;
  /// [backgroundColor] is the background color of the app bar.
  final Color? backgroundColor;

  /// Creates an [AppBarCommon] widget.
  const AppBarCommon({
    Key? key,
    this.title = "",
    this.actions,
    this.bottomWidget,
    this.onPressed,
    this.titleWidget,
    this.leadingWidget,
    this.centerTitle = true,
    this.leading = true,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarCommonContent(
      leading: leading,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      bottomWidget: bottomWidget,
      onPressed: onPressed,
      titleWidget: titleWidget,
      leadingWidget: leadingWidget,
      fontSize: fontSize,
      fontWeight: fontWeight,
      backgroundColor: backgroundColor,);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

class AppBarCommonContent extends StatelessWidget {
  /// [title] is the text to be displayed in the app bar.
  final String title;

  /// [titleWidget] is an optional widget to be displayed instead of text.
  final Widget? titleWidget;

  /// [centerTitle] determines whether the title should be centered.
  final bool centerTitle;

  /// [leading] determines whether to display the leading icon.
  final bool leading;

  /// [leadingWidget] is an optional widget to be displayed instead of the leading icon.
  final Widget? leadingWidget;
  final PreferredSizeWidget? bottomWidget;

  /// [actions] is a list of widgets to be displayed as actions on the app bar.
  final List<Widget>? actions;

  /// [fontSize] is the font size of the title.
  final double? fontSize;

  /// [fontWeight] is the font weight of the title.
  final FontWeight? fontWeight;

  /// [onPressed] is the callback function when the leading icon is pressed.
  final VoidCallback? onPressed;

  /// [backgroundColor] is the background color of the app bar.
  final Color? backgroundColor;

  /// Creates an [AppBarCommonContent] widget.
  const AppBarCommonContent({
    Key? key,
    this.title = "",
    this.centerTitle = true,
    this.leading = true,
    this.actions,
    this.bottomWidget,
    this.onPressed,
    this.titleWidget,
    this.leadingWidget,
    this.fontSize,
    this.fontWeight,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: !leading ? 0 : null,
      leading: !leading
          ? const SizedBox.shrink()
          : (leadingWidget ??
          IconButton(
            onPressed: onPressed ??
                    () {
                  if (Navigator.canPop(context)) context.pop();
                },
            icon: const Icon(
              CupertinoIcons.arrow_left,
              color: AppColors.black,
            ),
          )),
      centerTitle: centerTitle,
      automaticallyImplyLeading: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      titleSpacing: 5.w,
      title: titleWidget ??
          AppText(
            title,
            fontSize: fontSize ?? 22.sp,
            fontWeight: fontWeight ?? FontWeight.w600,
            fontFamily: AppFonts.cabinVariable,
          ),
      actions: actions,
      bottom: bottomWidget,
    );
  }

}
