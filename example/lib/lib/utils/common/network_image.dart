import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/assets/app_image_path.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_common_image.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';


Widget customNetWorkImageBoxRounded({
  required String? imageUrl,
  void Function()? onTap,
  double? width,
  double? height,

}) =>
    AppInkWell(
      onTap: onTap,
      child: CachedNetworkImage(
        width: width ?? 50.h,
        height: height ?? 50.h,
        imageUrl: imageUrl ?? "",
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        progressIndicatorBuilder: (_, __, progress) => getImageLoadingWidget(
          width: width ?? 50.h,
          height: height ?? 50.h,
          shape: BoxShape.rectangle
        ),
        errorWidget: (context, url, error) => getAppLogoErrorWidget(
          width: width ?? 50.h,
          height: height ?? 50.h,
        ),
      ),
    );

List<Widget> getMoreLoading({bool row=false})=>[
  row?5.xWidth: 5.yHeight,
  getCustomLoading(size: 25.h),
  row?5.xWidth:10.yHeight,
];

Center getCustomShimmerLoading({
  double? height,
  double? width,
  Color? color,
  double strokeWidth = 1.0,
}) =>
    Center(
      child: Shimmer.fromColors(
        baseColor: baseColorShimmer,
        highlightColor: highlightColorShimmer,
        child: Container(
          color: AppColors.white,
        ),
      ),
    );

Widget imageBox(
  BuildContext context, {
  double? size,
  double height = 0.05,
  double width = 0.1,
  Color? backgroundColor,
  String? svgImage,
  Color? colorSvgImage,
  BoxShape boxShape = BoxShape.rectangle,
  EdgeInsetsGeometry? padding,
  String? image,
  BoxFit fit = BoxFit.contain,
}) {
  return Container(
      padding: padding,
      decoration: BoxDecoration(
        shape: boxShape,
        color:
            (svgImage == null && image == null) ? Colors.red : backgroundColor,
      ),
      height: MediaQuery.sizeOf(context).height * (size ?? height),
      width: MediaQuery.sizeOf(context).height *
          (size != null ? (size * 2) : width),
      child: svgImage != null
          ? FittedBox(
              child: SvgPicture.asset(
              svgImage,
              color: colorSvgImage,
            ))
          : image != null
              ? FittedBox(
                  fit: fit,
                  child: Image.asset(
                    image,
                  ))
              : const SizedBox());
}
