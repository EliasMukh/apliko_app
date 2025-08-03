// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../../../index.dart';

class AnimatedField extends StatelessWidget {
  const AnimatedField({Key? key, required this.isRegister, required this.child})
    : super(key: key);

  final bool isRegister;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 330.duration,
      constraints: BoxConstraints(
        minHeight: isRegister ? 0 : 0,
        maxHeight: isRegister ? 110 : 0,
      ),
      child: AnimatedOpacity(
        duration: 330.duration,
        opacity: isRegister ? 1 : 0,
        child: AnimatedSlide(
          duration: 330.duration,
          offset: Offset(isRegister ? 0 : -2, 0),
          child: child,
        ),
      ),
    );
  }
}
