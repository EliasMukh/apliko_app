// ignore: unnecessary_import
import 'package:apliko/core/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../../../index.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget(this.message, this.onRefresh, {super.key});
  final String message;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(message, textAlign: TextAlign.center, style: largeStyle()),
        20.hSpace,
        InkWell(onTap: onRefresh, child: const Icon(Icons.refresh)),
      ],
    );
  }
}
