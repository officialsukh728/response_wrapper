import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sample/business_logics/blocs/toggle_blocs/toggle_blocs.dart';
import 'package:sample/business_logics/service/all_getter_setter.dart';
import 'package:sample/utils/common/AppColors.dart';
import 'package:sample/utils/common/app_common_button.dart';
import 'package:sample/utils/common/app_config.dart';
import 'package:sample/utils/common/app_text.dart';
import 'package:sample/utils/common/navigator_extension.dart';
import 'package:sample/utils/theme/app_theme.dart';

class AppDropDownSearch extends StatelessWidget {
  final List<String> items;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool enabled;
  final bool? readOnly;
  final Color? fillColor;
  final String? labelText;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? borderRadius;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autovalidateMode;

  const AppDropDownSearch({
    Key? key,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.fillColor,
    this.validator,
    this.obscureText,
    this.readOnly,
    this.onChanged,
    this.height,
    this.width,
    this.maxLength,
    this.maxLines = 1,
    this.borderColor,
    this.onTap,
    this.inputFormatters,
    this.contentPadding,
    this.padding,
    this.focusNode,
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.items = const <String>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DropdownSearch<String>(
        selectedItem:controller?.text==null||controller?.text.isEmpty==true?null: controller?.text,
        items: items,
        onChanged: (String? value) {
          if (value == null) return;
          controller?.text = value;
          onChanged?.call(value);
        },
        validator: validator,
        popupProps: PopupProps.menu(
          fit: FlexFit.tight,
          constraints: BoxConstraints(maxHeight: 210.h),
        ),
        autoValidateMode: autovalidateMode,
        dropdownButtonProps: const DropdownButtonProps(),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: appInputDecoration(
            context: context,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            borderRadius: borderRadius,
            fillColor: fillColor,
            labelText: labelText,
            borderColor: borderColor,
            enabled: enabled,
            contentPadding: contentPadding,
          ),
        ),
      ),
    );
  }
}

class AppTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final bool enabled;
  final bool boxShadow;
  final bool ignoring;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? borderRadius;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final void Function(String?)? onSaved;
  final TextInputAction? textInputAction;
  final InputBorder? enabledBorder;
  final AutovalidateMode? autovalidateMode;
final void Function(String)? onFieldSubmitted;

  const AppTextFormField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.enabled = true,
    this.ignoring = false,
    this.boxShadow = false,
    this.textInputAction,
    this.hintText,
    this.enabledBorder,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.fillColor,
    this.validator,
    this.obscureText,
    this.readOnly,
    this.onChanged,
    this.height,
    this.width,
    this.maxLength,
    this.maxLines = 1,
    this.borderColor=AppColors.oceanBlue,
    this.onTap,
    this.inputFormatters,
    this.contentPadding,
    this.padding,
    this.focusNode,
    this.labelText,
    this.onSaved,
    this.onFieldSubmitted,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: IgnorePointer(
        ignoring: ignoring,
        child: TextFormField(
          onTap: onTap,
          focusNode: focusNode,
          // enabled: enabled,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          inputFormatters: inputFormatters,
          autovalidateMode: autovalidateMode,
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText ?? false,
          maxLength: maxLength,
          maxLines: maxLines,
          onSaved: onSaved,
          readOnly: readOnly ?? false,
          textInputAction: textInputAction ?? TextInputAction.done,
          decoration: appInputDecoration(
            context: context,
            hintText: hintText,
            enabled: enabled,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            borderRadius: borderRadius ?? 19.r,
            fillColor: fillColor,
            borderColor: borderColor,
            labelText: labelText,
            contentPadding: contentPadding ??
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
            enabledBorder: enabledBorder,
          ),
        ),
      ),
    );
  }
}

InputDecoration appInputDecoration({
  required BuildContext context,
  String? hintText,
  String? labelText,
  Widget? prefixIcon,
  Widget? suffixIcon,
  double? borderRadius,
  Color? fillColor,
  Color? borderColor,
  required bool enabled,
  EdgeInsetsGeometry? contentPadding,
  InputBorder? enabledBorder,
}) =>
    InputDecoration(
      filled: true,
      hintText: hintText,
      labelText: labelText,
      prefixIconColor: borderColor??AppColors.oceanBlue,
      suffixIconColor: borderColor??AppColors.oceanBlue,
      prefixIcon: prefixIcon != null
          ? Padding(
              padding: EdgeInsets.only(
                  top: 5.h,
                  bottom: 5.h,
                right: 5.w,
                  left: 20.w,
              ),
              child: prefixIcon,
            )
          : null,
      suffixIcon: suffixIcon != null
          ? Padding(
        padding: EdgeInsets.only(
          top: 5.h,
          bottom: 5.h,
          left: 5.w,
          right: 20.w,
        ),
              child: SizedBox(
                child: suffixIcon,
              ),
            )
          : null,
      iconColor: AppColors.primaryColor,
      fillColor: !(enabled)
          ? Colors.black.withOpacity(0.15)
          : (fillColor ?? Colors.white),
      contentPadding: contentPadding ?? EdgeInsets.only(left: 10.w),
      hintStyle: Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 14.sp,
        color: borderColor??AppColors.oceanBlue,
        fontWeight: FontWeight.w400,),
      labelStyle: Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 14.sp, color: AppColors.greyColor),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        borderSide: BorderSide(
            color: !(enabled)
                ? Colors.grey
                : borderColor ?? AppColors.textFieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        borderSide: BorderSide(
            color: !(enabled)
                ? Colors.transparent
                : borderColor ?? AppColors.textFieldBorder),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        borderSide: BorderSide(color: !(enabled) ? Colors.grey : Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 10.r),
        borderSide: BorderSide(color: !(enabled) ? Colors.grey : Colors.red),
      ),
      // border: OutlineInputBorder(
      //   borderRadius: BorderRadius.circular(borderRadius??10.r),
      //   borderSide:  BorderSide(color: borderColor?? AppColors.primaryColor),
      // ),
    );

class AppTextFieldHeader extends StatelessWidget {
  final String title;
  final String? fontFamily;
  final String? optionalText;
  final bool isRequired;
  final bool isOptional;
  final double? fontSize;
  final Color? textColor;
  final void Function()? onTap;
  final FontWeight? fontWeight;
  final MainAxisAlignment mainAxisAlignment;

  const AppTextFieldHeader({
    super.key,
    required this.title,
    this.isRequired = false,
    this.fontSize,
    this.onTap,
    this.optionalText,
    this.fontFamily,
    this.fontWeight,
    this.textColor,
    this.isOptional = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:mainAxisAlignment ,
      children: [
        AppInkWell(
          onTap: onTap,
          child: RichText(
            text: TextSpan(
              text: title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: fontSize ?? 14.sp,
                color: textColor??Colors.black,
                fontFamily: fontFamily,
                fontWeight: fontWeight ?? FontWeight.w400,
              ),
              children: [
                if (isOptional)
                  TextSpan(
                    text:optionalText?? " (Optional)",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: fontFamily,
                      fontSize: fontSize ?? 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                if (isRequired)
                  TextSpan(
                    text: "*",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: fontFamily,
                      fontSize: fontSize ?? 14.sp,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AppCheckBox extends Flex {
  final bool value;
  final String title;
  final TextStyle? style;
  final BoxShape shape;
  final BuildContext context;
  final ValueChanged<bool> onTap;

  AppCheckBox({
    Key? key,
    this.style,
    this.shape=BoxShape.rectangle,
required this.title,
    required this.value,
    required this.context,
    required this.onTap,
  }) : super(
    key: key,
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      BlocBuilder<CheckBoxToggleBloc, bool>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              onTap(!state);
              context.read<CheckBoxToggleBloc>().add(!state);
            },
            child: Container(
              height: AppConfig.width * 0.05,
              width: AppConfig.width * 0.05,
              decoration: BoxDecoration(
                shape: shape,
                      // gradient: !value ? null : getLinearGradient,
                      border: Border.all(color: Color(0xff0E0642)),
                      borderRadius: shape == BoxShape.circle
                          ? null
                          : BorderRadius.circular(5.r),
                    ),
              child: !value
                  ? null
                  : Center(
                child: Icon(
                  Icons.done,
                  size: 15.sp,
                  color: AppColors.black,
                ),
              ),
            ),
          );
        },
      ),
      10.widthBox,
      if (title.isNotEmpty)
        AppText(
          title,
          style: style ??
              TextStyle(
                fontSize: 14.sp,
                      fontFamily: AppFonts.cabinVariable,
                    ),
        ).paddingAll(3.0),
    ],
  ) {
    resetBloc();
  }

  void resetBloc() => context.read<CheckBoxToggleBloc>().add(false);
}

class AppCustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final bool enabled;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? borderRadius;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? padding;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;

  const AppCustomTextField({
    Key? key,
    this.controller,
    this.keyboardType,
    this.onSubmitted,
    this.enabled = true,
    this.textInputAction,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.fillColor,
    this.validator,
    this.obscureText,
    this.readOnly,
    this.onChanged,
    this.height,
    this.width,
    this.maxLength,
    this.maxLines = 1,
    this.borderColor,
    this.onTap,
    this.inputFormatters,
    this.contentPadding,
    this.padding,
    this.focusNode,
    this.labelText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly ?? false,
      minLines: maxLines,
      controller: controller,
      obscureText: obscureText ?? false,
      maxLines: maxLines,
      // decoration: InputDecoration(
      //   suffixIcon: suffixIcon,
      //   border: InputBorder.none,
      // ),
      decoration: appInputDecoration(
        context: context,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        borderRadius: borderRadius,
        fillColor: fillColor,
        labelText: labelText,
        borderColor: borderColor,
        enabled: enabled,
        contentPadding: contentPadding,
      ),
    );
  }
}

class CommaTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue,) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final formatter = NumberFormat('#,###.##');
    String newText = newValue.text.replaceAll(',', '');
    if (newText.contains('.')) {
      List<String> parts = newText.split('.');
      String integerPart = formatter.format(int.parse(parts[0]));
      newText = '$integerPart.${parts[1]}';
    } else {
      newText = formatter.format(int.parse(newText));
    }

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
