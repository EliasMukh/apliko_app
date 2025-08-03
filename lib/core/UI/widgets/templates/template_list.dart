import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.itemBuilder,
    required this.count,
    this.padding,
    this.paddingValue,
  });
  final Widget Function(int) itemBuilder;
  final int count;
  final double? paddingValue;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.all(paddingValue ?? 20),
      itemCount: count,
      itemBuilder: (_, index) => itemBuilder(index),
      separatorBuilder: (_, index) => const SizedBox(height: 27),
    );
  }
}
