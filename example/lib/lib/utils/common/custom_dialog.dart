import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/navigator_extension.dart';

/// A dialog widget with customizable content and actions.
class CustomDialog extends StatelessWidget {
  /// The height of the dialog.
  final double? height;

  /// The title of the dialog.
  final String? title;

  /// The font size of the title.
  final double? titleFontSize;

  /// The subtitle of the dialog.
  final String? subTitle;

  /// The font size of the subtitle.
  final double? subTitleFontSize;

  /// The widget to be displayed as the button.
  final Widget? button;

  /// The title for the cancel action.
  final String? cancelTitle;

  /// A boolean flag to enable/disable the cancel title.
  final bool cancelTitleEnable;

  /// The title for the bottom action.
  final String? bottomTitle;

  /// The callback function for tapping the bottom title.
  final Function()? onTapBottomTitle;

  const CustomDialog({
    Key? key,
    this.height,
    this.title,
    this.titleFontSize,
    this.subTitle,
    this.subTitleFontSize,
    this.button,
    this.cancelTitle,
    this.cancelTitleEnable = true,
    this.bottomTitle,
    this.onTapBottomTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 30.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(21.5.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              title ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: titleFontSize ?? 22.sp),
            ),
            20.yHeight,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: AppText(
                subTitle ?? "",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: subTitleFontSize ?? 16.sp),
                textAlign: TextAlign.center,
              ),
            ),
            20.yHeight,
            button ?? const SizedBox.shrink(),
            15.yHeight,
            if (cancelTitleEnable)
              AppInkWell(
                onTap: () => context.pop(),
                child: AppText(
                  cancelTitle ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.redColor),
                ),
              ),
            if ((bottomTitle ?? "").isNotEmpty) 15.yHeight,
            if ((bottomTitle ?? "").isNotEmpty)
              AppInkWell(
                onTap: onTapBottomTitle,
                child: AppText(
                  bottomTitle ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.redColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
