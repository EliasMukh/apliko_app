import 'package:aplico/core/utils/lang.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aplico/index.dart';

class CustomBackButton extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const CustomBackButton({this.size, this.onTap, this.isCancel = false});
  final VoidCallback? onTap;
  final bool isCancel;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => context.pop(),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.backgroundColor,
          border: Border.all(width: 4, color: AppColors.greyText),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(.16),
            ),
          ],
        ),
        child: Transform.flip(
          flipX: !AppLanguage.isLTR,
          child: SvgPicture.asset(
            isCancel ? Assets.assetsIconsCancel : Assets.assetsIconsBack,
            height: (size ?? 22).w,
          ).padding(all: 6),
        ),
      ),
    );
  }
}
