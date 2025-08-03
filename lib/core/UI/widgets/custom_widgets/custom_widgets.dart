import 'package:apliko/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import 'package:easy_localization/easy_localization.dart' as localized;
import '../../styles/colors.dart';
import '../../styles/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.label,
    this.width,
    this.color,
    this.style,
    this.vPadding,
    this.fontSize = 19,
    this.isBold = false,
    this.isDisable = false,
    this.isLoading = false,
    this.elevation,
    this.textStyle,
  });
  final bool isBold, isDisable, isLoading;
  final TextStyle? textStyle;
  final double? width, vPadding;
  final double? fontSize;
  final double? elevation;
  final Color? color;
  final ButtonStyle? style;
  final String label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style:
          style ??
          buttonStyle(color: color, padding: vPadding, elevation: elevation),
      child:
          isLoading
              ? const CircularProgressIndicator.adaptive()
              : Text(
                label.tr(),
                style:
                    textStyle ??
                    infoStyle(
                      size: fontSize,
                      isBold: isBold,
                      color: Colors.white,
                    ),
              ),
    ).width(width ?? double.infinity);
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.textColor,
    this.isBold = false,
    this.fontSize,
  });
  final double? fontSize;
  final bool isBold;
  final Color? textColor;
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        // padding: EdgeInsets.all(12),
      ),
      child: Text(
        label.tr(),
        style: labelStyle(
          color: textColor,
          isBold: isBold,
          size: fontSize ?? 14,
        ),
      ),
    );
  }
}

class CustomOutLinedButton extends StatelessWidget {
  const CustomOutLinedButton({
    super.key,
    this.onPressed,
    this.label,
    this.color,
    this.radius = 12,
    this.child,
    this.padding = 12,
  });
  final Widget? child;
  final double radius, padding;
  final Color? color;
  final String? label;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.all(padding),
        shape: RoundedRectangleBorder(borderRadius: radius.radius),
        side: BorderSide(color: color ?? AppColors.primary, width: 1),
      ),
      child:
          child ??
          TextTr(label!, style: labelStyle(color: color ?? AppColors.primary)),
    );
  }
}

class CustomText extends StatelessWidget {
  const CustomText(this.label, {super.key, this.color, this.size, this.align});
  final String label;
  final Color? color;
  final TextAlign? align;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      style: TextStyle(color: color, fontSize: size),
    );
  }
}

class TextTr extends StatelessWidget {
  const TextTr(
    this.label, {
    super.key,
    this.color,
    this.size,
    this.align,
    this.style,
    this.args,
    this.textDirection,
    this.weight,
  });
  final String label;
  final Color? color;
  final FontWeight? weight;
  final TextStyle? style;
  final TextAlign? align;
  final double? size;
  final List<String>? args;
  final TextDirection? textDirection;
  @override
  Widget build(BuildContext context) {
    return Text(
      label.tr(args: args),
      textAlign: align,
      style:
          style ?? TextStyle(color: color, fontSize: size, fontWeight: weight),
      textDirection: textDirection,
    );
  }
}

class UnderlineTextWidget extends StatelessWidget {
  const UnderlineTextWidget(
    this.label, {
    super.key,
    required this.onTap,
    this.color,
    this.size,
  });
  final double? size;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label.tr(),
        style: TextStyle(
          fontSize: size ?? 12,
          decoration: TextDecoration.underline,
          decorationColor: color,
          color: color,
        ),
      ),
    );
  }
}
