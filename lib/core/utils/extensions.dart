import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import './funcs.dart';

import 'size_config.dart';

RegExp _decimalZeroPoint = RegExp(r'([.]*0)(?!.*\d)');

extension NumberExtension on num {
  double get hPercent => SizeConfig.blockSizeVertical * this;

  double get wPercent => SizeConfig.blockSizeHorizontal * this;

  Duration get duration => Duration(milliseconds: toInt());

  BorderRadius get radius => BorderRadius.circular(toDouble());

  SizedBox get wSpace => SizedBox(width: toDouble());
  SizedBox get hSpace => SizedBox(height: toDouble());
  String get toOneDecimal => toStringAsFixed(1).replaceAll(_decimalZeroPoint, '');
}

extension NotNull on Object? {
  bool get notNull => this != null;
}

extension StrNullEx on String? {
  bool get notNullEmpty => this != null && this!.isNotEmpty;
}

extension StrEx on String {
  String get t => this.tr();
}

extension DateEx2 on DateTime? {
  // String get toDateString => '$year-$month-$day';
  DateTime? get date => this == null ? null : DateTime(this!.year, this!.month, this!.day);
  String? format([String? pattern]) => formatDateOr(this, pattern: pattern);
  String? get dateToIso => this?.toUtc().toIso8601String();
}

extension DateEx on DateTime {
  String get toDateString => '$year-$month-$day';
  String format([String? pattern]) => formatDate(this, pattern: pattern);
}

extension EnumExtension on Enum {
  String get nameTr => name.tr();
}
