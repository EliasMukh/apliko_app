// ignore: unnecessary_import
import 'package:apliko/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:apliko/index.dart';
import '../widgets/custom_widgets/custom_widgets.dart';

class TemplateDialog extends StatelessWidget {
  const TemplateDialog({
    super.key,
    required this.title,
    this.titleArgs,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    this.isLoading = false,
    this.isPopOnAction = true,
    this.secondActionLabel,
  });
  final bool isLoading;
  final bool isPopOnAction;
  final String title, actionLabel;
  final String? subtitle, secondActionLabel;
  final List<String>? titleArgs;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 12.radius),
      insetPadding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 25.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 30,
              color: AppColors.greyText,
            ).alignment(AlignmentDirectional.centerEnd).padding(bottom: 10),
          ),
          TextTr(
            title,
            align: TextAlign.center,
            args: titleArgs,
            style: labelStyle(
              color: AppColors.greyText,
              isBold: true,
              size: 18,
            ),
          ).padding().alignment(Alignment.center),
          12.verticalSpace,
          if (subtitle.notNull)
            TextTr(
              subtitle!,
              align: TextAlign.center,
              style: infoStyle(color: AppColors.greyText),
            ).padding().alignment(Alignment.center),
          18.verticalSpace,
          CustomOutLinedButton(
            color: AppColors.red,
            child:
                isLoading
                    ? const CircularProgressIndicator.adaptive()
                    : TextTr(actionLabel),
            onPressed: () {
              onAction();
              if (isPopOnAction) Navigator.pop(context);
            },
          ),
          if (secondActionLabel.notNull) 6.verticalSpace,
          if (secondActionLabel.notNull)
            CustomOutLinedButton(
              color: AppColors.red,
              child:
                  isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : TextTr(secondActionLabel!),
              onPressed: () {
                onAction();
                if (isPopOnAction) Navigator.pop(context);
              },
            ),
          6.verticalSpace,
          CustomButton(
            label: 'dismiss',
            textStyle: infoStyle(color: AppColors.greyText),
            color: AppColors.primary,
            elevation: 0,
            onPressed: () => Navigator.pop(context),
          ),
          12.verticalSpace,
        ],
      ).padding(vertical: 12.h, horizontal: 25.w),
    );
  }
}
