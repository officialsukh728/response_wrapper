import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/utils/theme/app_theme.dart';

/// Custom InkWell widget.
class AppInkWell extends StatelessWidget {
  /// Function to call when the inkwell is tapped.
  final void Function()? onTap;

  /// The widget that appears inside the InkWell.
  final Widget? child;

  /// The border radius of the InkWell.
  final BorderRadius? borderRadius;

  const AppInkWell({Key? key, this.onTap, this.child, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: Colors.transparent,
        // splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        child: child,
      ),
    );
  }
}

/// Custom button widget commonly used in the app.
class AppCommonButton extends StatelessWidget {
  /// The title text of the button.
  final String title;

  /// Function to call when the button is tapped.
  final void Function()? onTap;

  /// The height of the button.
  final double? height;

  /// The width of the button.
  final double? width;

  /// The font size of the button text.
  final double? fontSize;

  /// The background color of the button.
  final Color? backGroundColor;

  /// Flag to indicate if the button is in loading state.
  final bool loading;

  /// The color of the border.
  final Color? borderColor;

  /// The first icon widget displayed in the button.
  final Widget? icon1;

  /// The second icon widget displayed in the button.
  final Widget? icon2;

  /// The font weight of the button text.
  final FontWeight? fontWeight;

  /// The color of the button text.
  final Color textColor;

  /// The border radius of the button.
  final double? borderRadius;

  /// Flag to indicate if the button should have gradient background.
  final bool gradient;

  /// Flag to indicate if the button is primary.
  final bool isPrimary;

  /// Flag to indicate if the button is enabled.
  final bool enable;

  /// The alignment of the children within the button.
  final MainAxisAlignment mainAxisAlignment;
 final BuildContext? context;
 final num? progress;
  const AppCommonButton({
    Key? key,
    this.context,
    required this.title,
    required this.onTap,
    this.height,
    this.width,
    this.fontSize,
    this.backGroundColor,
    this.loading = false,
    this.borderColor,
    this.icon1,
    this.icon2,
    this.progress,
    this.fontWeight,
    this.textColor = Colors.black,
    this.borderRadius,
    this.gradient = true,
    this.enable = true,
    this.isPrimary = false,
    this.mainAxisAlignment = MainAxisAlignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        AppInkWell(
          onTap: !enable ? null : (loading == true ? null : onTap),
          child: Container(
            width: width ?? MediaQuery.sizeOf(context).width * 0.4,
            height: height ?? 60.h,
            decoration: BoxDecoration(
              color: !enable
                  ? Colors.grey
                  : (backGroundColor ??
                  (userIsAdvertiser
                      ? AppColors.primaryColor
                      : AppColors.secondaryColor)),
              borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
              border: Border.all(color: borderColor ?? Colors.transparent,width: 0.5.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon1 != null && loading == false) icon1!,
                if (icon1 != null && loading == false) 10.widthBox,
                if (loading)
                  SizedBox(
                    height: 20.h,
                    width: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.w,
                      value: progress != null ? progress! / 100 : null,
                      color: progress == null ? textColor:null,
                      backgroundColor: progress == null ?null:AppColors.white.withOpacity(0.3),
                      valueColor:progress == null ?null: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                else
                  AppText(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: fontWeight ?? FontWeight.w700,
                      fontFamily: AppFonts.cabinVariable,
                      overflow: TextOverflow.ellipsis,
                      color: textColor,
                    ),
                  ),
                if (icon2 != null && loading == false) 10.widthBox,
                if (icon2 != null && loading == false) icon2!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}/*
Widget AppCommonButton({
  required BuildContext context,
  required String title,
  required void Function()? onTap,
  double? height,
  double? width,
  double? fontSize,
  Color? backGroundColor,
  bool loading = false,
  Color? borderColor,
  Widget? icon1,
  Widget? icon2,
  FontWeight? fontWeight,
  Color textColor = Colors.black,
  double? borderRadius,
  bool gradient = true,
  bool enable = true,
  bool isPrimary = false,
  num? progress,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    children: [
      AppInkWell(
        onTap: !enable ? null : (loading == true ? null : onTap),
        child: Container(
          width: width ?? MediaQuery.sizeOf(context).width * 0.4,
          height: height ?? 60.h,
          decoration: BoxDecoration(
            color: !enable
                ? Colors.grey
                : (backGroundColor ??
                (userIsAdvertiser
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor)),
            borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
            border: Border.all(color: borderColor ?? Colors.transparent,width: 0.5.w),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon1 != null && loading == false) icon1!,
              if (icon1 != null && loading == false) 10.widthBox,
              if (loading)
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.w,
                    value: progress != null ? progress / 100 : null,
                    color: progress == null ? textColor:null,
                    backgroundColor: progress == null ?null:AppColors.white.withOpacity(0.3),
                    valueColor:progress == null ?null: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              else
                AppText(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: fontWeight ?? FontWeight.w700,
                    fontFamily: AppFonts.cabinVariable,
                    overflow: TextOverflow.ellipsis,
                    color: textColor ?? Colors.black,
                  ),
                ),
              if (icon2 != null && loading == false) 10.widthBox,
              if (icon2 != null && loading == false) icon2!,
            ],
          ),
        ),
      ),
    ],
  );
}
*/

class AppMiniButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final FontWeight? fontWeight;

  const AppMiniButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.fontWeight,
    this.backgroundColor, this.width, this.height, this.fontSize, this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        maximumSize: Size(width??61.w, height??33.h),
        minimumSize: Size(width??61.w, height??33.h),
        backgroundColor:backgroundColor?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius??7.r),
        ),
      ),
      child: Center(
        child: AppText(
          title,
          fontSize: fontSize??10.sp,
          fontWeight: fontWeight??FontWeight.w400,
        ),
      ),
    );
  }
}
