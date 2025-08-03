import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

class EmptyInfoWidget extends StatelessWidget {
  const EmptyInfoWidget({
    super.key,
    this.message,
    this.topPadding,
    this.onRefresh,
  });
  final String? message;
  final double? topPadding;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message ?? 'No results are found',
          style: labelStyle(size: 22, color: AppColors.primary),
        ).padding(top: topPadding),
        InkWell(
          onTap: onRefresh,
          child: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
