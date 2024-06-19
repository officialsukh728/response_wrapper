import 'package:sample/utils/common/app_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:shimmer/shimmer.dart';

/// Widget to display when no data is found.
class NoDataFoundWidget extends StatelessWidget {
  /// The message to display when no data is found.
  final String? message;

  /// Callback function when tapped.
  final VoidCallback? onTap;

  const NoDataFoundWidget({Key? key, this.message, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: AppText(
                message ?? "No Data Found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display an error when loading an image.
Widget getAppLogoErrorWidget({
  double? width,
  double? height,
  BoxBorder? border,
  BoxShape shape=BoxShape.rectangle,
}) {
  return Container(
    width: width ?? 40.h,
    height: height ?? 40.h,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: shape,
      border: border,
    ),
    child: const Center(child: Icon(Icons.error)),
  );
}

/// Widget to display when an image is loading.
Widget getImageLoadingWidget({
  double? width,
  double? height,
  BoxShape shape=BoxShape.rectangle,
  BoxBorder? border,
  BoxFit fit = BoxFit.contain,
}) {
  return Shimmer.fromColors(
    baseColor: baseColorShimmer,
    highlightColor: highlightColorShimmer,
    child: Container(
      width: width ?? 40.h,
      height: height ?? 40.h,
      decoration: BoxDecoration(
          color: AppColors.white, shape: shape,border:border),
      child: const SizedBox.shrink(),
    ),
  );
}

/// Widget to display an image with various sources.
class AppCommonImage extends StatelessWidget {
  /// The path of the image.
  final String imagePath;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// The fit of the image.
  final BoxFit fit;

  /// Flag indicating if the image is from a file.
  final bool file;

  /// The shape of the container.
  final BoxShape shape;
 final BoxBorder? border;
  /// Callback function when tapped.
  final void Function()? onTap;

  const AppCommonImage({
    Key? key,
    required this.imagePath,
    this.width,
    this.height,
    this.onTap,
    this.border,
    this.file = false,
    this.shape = BoxShape.rectangle,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file) {
      return GestureDetector(
        onTap: onTap,
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else if (imagePath.toLowerCase().endsWith('.svg')) {
      return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    } else if (imagePath.toLowerCase().startsWith('http')) {
      return GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          width: width ?? 50.h,
          height: height ?? 50.h,
          fit: fit,
          imageUrl: imagePath ?? "",
          imageBuilder: (context, imageProvider) => Container(
            width: width ?? 50.h,
            height: height ?? 50.h,
            decoration: BoxDecoration(
              shape: shape,
              border: border,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          progressIndicatorBuilder: (_, __, progress) => getImageLoadingWidget(
            width: width ?? 50.h,
            height: height ?? 50.h,
            shape: shape,
            fit: fit,
            border: border,
          ),
          errorWidget: (context, url, error) => getAppLogoErrorWidget(
            shape: shape,
            border: border,
            width: width ?? 50.h,
            height: height ?? 50.h,
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }
  }
}

/// Widget to display loading indicator.
List<Widget> getMoreLoading({bool row = false}) => [
  row ? 5.widthBox : 5.heightBox,
  getCustomLoading(height: 25.h, width: 25.h),
  row ? 5.widthBox : 10.heightBox,
];

/// Widget to display a custom loading indicator.
Center getCustomLoading({
  double? height,
  double? width,
  Color? color,
  double? size,
  double strokeWidth = 2.0,
}) =>
    Center(
      child: SizedBox(
        height: size ?? height ?? 40.h,
        width: size ?? width ?? 40.h,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth.w,
          color: color ?? AppColors.primaryColor,
        ),
      ),
    );
