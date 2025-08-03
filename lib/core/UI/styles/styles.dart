import 'package:aplico/core/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'font_sizse.dart';

TextStyle largeStyle({Color? color, double? size}) {
  return TextStyle(
    color: color ?? AppColors.black,
    fontSize: size ?? FontSize.xxl.toDouble(),
    fontWeight: FontWeight.w500,
  );
}

TextStyle infoStyle({Color? color, double? size, bool isBold = false}) {
  return TextStyle(
    color: color,
    fontSize: size ?? FontSize.m.toDouble(),
    fontWeight: isBold ? FontWeight.bold : null,
  );
}

TextStyle smallTextStyle({Color? color, double? size, bool isBold = false}) {
  return TextStyle(
    color: color,
    fontSize: size ?? FontSize.s.toDouble(),
    fontWeight: FontWeight.w400,
  );
}

TextStyle titleStyle({
  Color? color,
  double? size,
  bool isBold = false,
  FontWeight weight = FontWeight.normal,
}) {
  return TextStyle(
    color: color ?? AppColors.primary,
    fontSize: size ?? FontSize.xl.toDouble(),
    fontWeight: isBold ? FontWeight.bold : weight,
  );
}

ButtonStyle buttonStyle({
  Color? color,
  double? padding,
  double? radius,
  double? elevation,
}) {
  return ElevatedButton.styleFrom(
    backgroundColor: color ?? AppColors.primary,
    // ignore: deprecated_member_use
    foregroundColor: AppColors.backgroundColor.withOpacity(.5),
    padding: EdgeInsets.all(padding ?? 12),
    elevation: elevation ?? 4,
    shape: RoundedRectangleBorder(borderRadius: (radius ?? 12).radius),
  );
}

TextStyle labelStyle({
  Color? color,
  double? size,
  bool isBold = false,
  double? height,
}) {
  return TextStyle(
    color: color ?? AppColors.primary,
    fontSize: size ?? FontSize.l.toDouble(),
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    height: height,
  );
}

TextStyle subLabelStyle({
  Color? color,
  double? size,
  bool isBold = false,
  double? height,
}) {
  return TextStyle(
    color: color ?? AppColors.primary,
    fontSize: size ?? FontSize.s.toDouble(),
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    height: height,
  );
}

InputDecoration getFieldDecoration({
  String? label,
  String? hint,
  Widget? suffixIcon,
  InputBorder? border,
  Widget? prefixIcon,
  double? hPadding,
  double? vPadding,
  bool filled = false,
  Color? fillColor,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: infoStyle(size: 12),
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
    fillColor: fillColor,
    filled: filled,
    border: border ?? inputBorder,
    enabledBorder: border ?? inputBorder,
    focusedBorder: focusBorder,
    disabledBorder: border ?? inputBorder,
    errorBorder: errorBorder,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    prefixIconConstraints: const BoxConstraints(maxWidth: 70),
    focusedErrorBorder: errorBorder,
    isDense: false,
    contentPadding: EdgeInsets.symmetric(
      horizontal: hPadding ?? 12,
      vertical: vPadding ?? 14,
    ),
  );
}

InputBorder get focusBorder => OutlineInputBorder(
  borderRadius: 12.radius,
  borderSide: const BorderSide(color: AppColors.primary, width: 1),
);

InputBorder get inputBorder =>
    OutlineInputBorder(borderRadius: 12.radius, borderSide: BorderSide.none);

InputBorder get errorBorder => OutlineInputBorder(
  borderRadius: 12.radius,
  borderSide: const BorderSide(color: Colors.red),
);
