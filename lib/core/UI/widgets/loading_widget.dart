import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.color, this.hPadding});
  final Color? color;
  final double? hPadding;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation(color),
    ).center().padding(top: hPadding);
  }
}
