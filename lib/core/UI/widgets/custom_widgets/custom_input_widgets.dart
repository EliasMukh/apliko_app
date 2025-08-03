// ignore_for_file: use_key_in_widget_constructors

import 'package:apliko/core/utils/validator.dart';
import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:apliko/index.dart';
import '../../../logical/errors/error_model.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import '../../styles/font_sizse.dart';

class CustomInputField extends StatefulWidget {
  final InputBorder? inputBorder;

  const CustomInputField({
    this.initValue,
    this.label,
    this.inputBorder,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.outerLabel,
    this.isRequired = false,
    this.isObscureText = false,
    this.isAutoValidate = false,
    this.enabled = true,
    this.errorDictionary,
    this.action = TextInputAction.next,
    this.keyboardType,
    this.errorDictionaryKey,
    this.errorText,
    this.isEmail = false,
    this.customKey,
    this.hPadding,
    this.readOnly = false,
    this.isNumber = false,
    this.controller,
    this.maxLength,
    this.maxLines = 1,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.textDirection,
    this.hint,
  });
  final Icon? suffixIcon;
  final String? prefixIcon;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final double? hPadding;
  final Key? customKey;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextInputAction action;
  final bool isObscureText,
      isEmail,
      isNumber,
      isAutoValidate,
      readOnly,
      enabled;
  final String? initValue,
      outerLabel,
      label,
      errorText,
      errorDictionaryKey,
      hint;
  final ErrorDictionary? errorDictionary;
  final void Function(String?)? onSaved, onChanged;
  final String? Function(String?)? validator;
  final TextDirection? textDirection;
  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _isObscureText;
  late final TextInputType type;
  @override
  void initState() {
    if (widget.initValue != null && widget.controller != null) {
      widget.controller!.text = widget.initValue!;
    }
    _isObscureText = widget.isObscureText;
    if (widget.keyboardType != null) {
      type = widget.keyboardType!;
    } else if (widget.isNumber) {
      type = const TextInputType.numberWithOptions(
        signed: false,
        decimal: true,
      );
    } else if (widget.isEmail) {
      type = TextInputType.emailAddress;
    } else {
      type = TextInputType.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.outerLabel?.isNotEmpty != null,
          child: Column(
            children: [
              Text(
                widget.outerLabel ?? '',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: FontSize.l,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        TextFormField(
          key: widget.customKey,
          textDirection: widget.textDirection,
          cursorColor: AppColors.primary,
          maxLength: widget.maxLength,
          initialValue: widget.controller != null ? null : widget.initValue,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: _isObscureText,
          style: const TextStyle(fontSize: 16),
          keyboardType: type,
          autovalidateMode:
              widget.isAutoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
          textInputAction: widget.action,
          // inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          decoration: getFieldDecoration(
            label: widget.label?.tr(),
            hint: widget.hint?.tr(),
            border: widget.inputBorder,
            prefixIcon:
                widget.prefixIcon == null
                    ? null
                    : (widget.prefixIcon!.endsWith('svg'))
                    ? SvgPicture.asset(
                      widget.prefixIcon!,
                      height: 19,
                      colorFilter: const ColorFilter.mode(
                        AppColors.black,
                        BlendMode.srcIn,
                      ),
                    ).center()
                    : Image.asset(widget.prefixIcon!, height: 19),
            hPadding: widget.hPadding,
            filled: true,
            fillColor: AppColors.backgroundColor,
            suffixIcon:
                widget.isObscureText
                    ? InkWell(
                      onTap: () {
                        setState(() {
                          _isObscureText = !_isObscureText;
                        });
                      },
                      child: Icon(
                        _isObscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    )
                    : widget.suffixIcon,
          ),
          validator: (value) {
            final message =
                (widget.errorDictionary ?? []).toList().firstWhereOrNull((
                  element,
                ) {
                  return element.key == widget.errorDictionaryKey;
                })?.value;
            if (message != null) return message;

            if (widget.errorText != null &&
                widget.errorText!.isNotEmpty &&
                widget.errorText != '200') {
              return widget.errorText;
            }
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return 'this_field_is_required'.tr();
            }

            if (widget.isEmail && !Validator.email.isValid(value)) {
              return 'enter_a_valid_email_address'.tr();
            }

            return widget.validator?.call(value);
          },
          onSaved: widget.onSaved,
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

class CustomPopupWidget<T> extends StatefulWidget {
  const CustomPopupWidget({
    required this.onSelect,
    required this.items,
    required this.hint,
    this.initValue,
    super.key,
  });
  final T? initValue;
  final List<T> items;
  final String hint;
  final void Function(T) onSelect;

  @override
  State<CustomPopupWidget<T>> createState() => _CustomPopupWidgetState<T>();
}

class _CustomPopupWidgetState<T> extends State<CustomPopupWidget<T>> {
  final GlobalKey<PopupMenuButtonState> _key = GlobalKey();
  final txtCon = TextEditingController();
  T? _value;
  @override
  void initState() {
    if (widget.initValue != null) txtCon.text = getValueStr(widget.initValue)!;
    _value = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      key: _key,
      offset: const Offset(0, 6),
      initialValue: _value,
      itemBuilder:
          (_) =>
              widget.items
                  .map(
                    (item) => PopupMenuItem(
                      value: item,
                      child: Text(getValueStr(item)!),
                    ),
                  )
                  .toList(),
      onSelected: (val) {
        _value = val;
        txtCon.text = getValueStr(val) ?? '';
        setState(() {});
        widget.onSelect(val);
      },
      child: CustomInputField(
        readOnly: true,
        label: widget.hint,
        controller: txtCon,
        suffixIcon: const Icon(Icons.arrow_drop_down),
        onTap: () {
          _key.currentState?.showButtonMenu();
        },
      ),
    );
  }

  String? getValueStr(e) {
    String str;
    if (e == null) return null;
    if (e is Enum) {
      str = e.name.characters.string;
    } else {
      str = e;
    }
    str = str.replaceFirst(
      str.characters.first,
      str.characters.first.toUpperCase(),
    );
    return str;
  }
}

class CustomDropdownField<T> extends StatelessWidget {
  const CustomDropdownField({
    required this.onSelect,
    required this.items,
    required this.hint,
    this.initValue,
    super.key,
    this.isRequired = false,
    this.isFilled = false,
  });

  final bool isRequired, isFilled;
  final T? initValue;
  final List<T> items;
  final String hint;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<T>(
        value: initValue,
        hint: Text(
          hint,
          style: const TextStyle(color: Colors.grey, fontSize: 18),
        ),
        decoration: getFieldDecoration(
          // hint: hint,
          filled: isFilled,
          hPadding: 0,
        ),
        validator: (value) {
          if (isRequired && value == null) return 'This field is required';
          return null;
        },
        onChanged: (val) {
          if (val == null) return;
          onSelect(val);
        },
        items:
            items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(getValueStr(item)!),
                  ),
                )
                .toList(),
      ),
    );
  }

  String? getValueStr(e) {
    String str;
    if (e == null) return null;
    if (e is Enum) {
      str = e.name.characters.string;
    } else {
      str = e.toString();
    }
    str = str.replaceFirst(
      str.characters.first,
      str.characters.first.toUpperCase(),
    );
    return str;
  }
}
