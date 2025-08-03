import 'package:apliko/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:apliko/core/UI/styles/styles.dart';
import 'package:apliko/core/UI/widgets/custom_widgets/custom_widgets.dart';
import 'package:styled_widget/styled_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String desc;
  final String assetPath;
  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.desc,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(assetPath),
        15.hSpace,
        TextTr(title, style: infoStyle(isBold: true)),
        TextTr(
          desc,
          style: subLabelStyle(size: 15),
          align: TextAlign.center,
        ).width(270),
      ],
    );
  }
}
