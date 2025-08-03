// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class MaterialInk extends StatelessWidget {
  const MaterialInk({
    this.onTap,
    this.onLongTap,
    required this.child,
    this.borderRadius,
    this.childPadding,
    this.color,
  });
  final Color? color;
  final VoidCallback? onTap, onLongTap;
  final double? childPadding;
  final Widget child;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: InkWell(
        splashColor: color,
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongTap,
        child: child.padding(all: childPadding),
      ),
    );
  }
}
