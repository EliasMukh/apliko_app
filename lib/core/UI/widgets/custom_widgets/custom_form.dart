// ignore_for_file: use_key_in_widget_constructors

import 'package:apliko/core/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../logical/errors/error_model.dart';

import 'custom_widgets.dart';

class CustomForm extends StatefulWidget {
  const CustomForm({
    required this.onSubmit,
    required this.children,
    // this.formKey,
    this.errorDictionary,
  });
  // final GlobalKey<FormState>? formKey;
  final VoidCallback onSubmit;
  final List<Widget> children;
  final ErrorDictionary? errorDictionary;

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  late final GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomForm oldWidget) {
    if (widget.errorDictionary != null) _formKey.currentState!.validate();
    super.didUpdateWidget(oldWidget);
  }

  Future<void> _submit() async {
    widget.errorDictionary?.clear();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    widget.onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 20,
              children: [...widget.children],
            ).padding(horizontal: 20, top: 30),
          ),
        ).expanded(),
        CustomButton(
          onPressed: _submit,
          label: 'Save',
          width: 100.wPercent,
        ).padding(horizontal: 20),
        const SizedBox(height: 30, width: 3),
      ],
    );
  }
}
