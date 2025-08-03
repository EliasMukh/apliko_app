import 'package:apliko/core/UI/styles/styles.dart';
import 'package:apliko/core/UI/widgets/back_button.dart';
import 'package:apliko/core/UI/widgets/custom_widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.leadingWidget = const CustomBackButton(),
    this.action,
    this.labelColor,
    this.label,
    this.showBackButton = true,
    this.withTopPadding = true,
  });

  final bool withTopPadding;
  final Color? labelColor;
  final Widget leadingWidget;
  final Widget? action;
  final String? label;
  final bool showBackButton;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.withTopPadding ? null : 70.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.label != null)
            TextTr(
              widget.label!,
              style: largeStyle(size: 20, color: widget.labelColor),
            ).padding(horizontal: 60.w).center(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (widget.showBackButton)
                  ? widget.leadingWidget.padding(horizontal: 20)
                  : Container(),
              widget.action?.padding(horizontal: 20) ?? const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    ).safeArea(top: widget.withTopPadding ? true : false, bottom: false);
  }
}
