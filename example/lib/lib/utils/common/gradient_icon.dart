import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';

/// A widget that displays an icon with a gradient effect.
class GradientIcon extends StatelessWidget {
  /// The icon data.
  final IconData icon;

  /// The size of the icon.
  final double size;

  const GradientIcon({
    Key? key,
    required this.icon,
    this.size = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return getLinearGradient.createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

/// A widget that displays a social image icon with gradient background.
class AppSocialImageIcon extends StatelessWidget {
  /// The callback function when the icon is tapped.
  final void Function() onTap;

  /// The type of social image icon.
  final AppSocialImageIconConst iconType;

  const AppSocialImageIcon({
    Key? key,
    required this.onTap,
    required this.iconType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: getLinearGradient,
        ),
        child: Center(
          child: getIconData(iconType),
        ),
      ),
    );
  }

  /// Returns the appropriate icon based on the icon type.
  Widget getIconData(AppSocialImageIconConst iconType) {
    switch (iconType) {
      case AppSocialImageIconConst.calling:
        return SvgPicture.string(
          'SVG Data for calling icon',
          width: 20.h,
          height: 20.h,
        );
      case AppSocialImageIconConst.whatsapp:
        return SvgPicture.string(
          'SVG Data for whatsapp icon',
          width: 25.h,
          height: 25.h,
        );
      case AppSocialImageIconConst.message:
        return SvgPicture.string(
          'SVG Data for message icon',
          width: 25.h,
          height: 25.h,
        );
      default:
        return Container();
    }
  }
}

/// Enumeration for different types of social image icons.
enum AppSocialImageIconConst {
  whatsapp,
  calling,
  message,
}
