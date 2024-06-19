import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:flutter/material.dart';
import 'package:sample/utils/theme/app_theme.dart';

/// A widget for displaying text with various customization options.
class AppText extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The font family of the text.
  final String? fontFamily;

  /// Whether to apply a gradient effect to the text.
  final bool gradient;

  /// The font size of the text.
  final double? fontSize;
  final double? height;
  final double? letterSpacing;

  /// The color of the text.
  final Color? color;

  /// The font weight of the text.
  final FontWeight? fontWeight;

  /// Additional text style to apply.
  final TextStyle? style;

  /// The alignment of the text within its container.
  final TextAlign? textAlign;

  /// The direction of the text.
  final TextDirection? textDirection;

  /// Whether the text should wrap if it exceeds the available horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// The maximum number of lines for the text to span.
  final int? maxLines;

  /// The strut style to use.
  final StrutStyle? strutStyle;

  /// The text height behavior to use.
  final TextHeightBehavior? textHeightBehavior;

  /// The locale for the text.
  final Locale? locale;

  /// Callback function for when the text is tapped.
  final void Function()? onTap;

  /// The linear gradient to apply when `gradient` is true.
  final LinearGradient? linearGradient;

  const AppText(
      this.text, {
        Key? key,
        this.onTap,
        this.fontFamily,
        this.height,
        this.letterSpacing,
        this.gradient = false,
        this.style,
        this.fontWeight,
        this.textAlign,
        this.textDirection,
        this.linearGradient,
        this.softWrap,
        this.overflow,
        this.maxLines,
        this.strutStyle,
        this.textHeightBehavior,
        this.locale,
        this.fontSize,
        this.color,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Text(
      text,
      key: key,
      textAlign: textAlign,
      textDirection: textDirection,
      softWrap: softWrap ?? true,
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      strutStyle: strutStyle,
      textHeightBehavior: textHeightBehavior,
      locale: locale,
      style: style ??
          Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: fontSize,
            height: height,
            letterSpacing: letterSpacing,
            fontFamily: fontFamily ?? AppFonts.cabinVariable,
            fontWeight: fontWeight ?? FontWeight.w400,
            color: color,
          ),
    );
    if (!gradient) {
      return AppInkWell(onTap: onTap, child: child);
    } else {
      return ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) =>
            (linearGradient ?? getLinearGradient).createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
        child: AppInkWell(
          onTap: onTap,
          child: child,
        ),
      );
    }
  }
}

