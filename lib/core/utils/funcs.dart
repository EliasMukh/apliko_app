import 'package:apliko/core/logical/constaints.dart';
import 'package:apliko/core/logical/errors/error_model.dart';
import 'package:apliko/core/logical/errors/failures.dart';
import 'package:apliko/core/logical/urls.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:fluttertoast/fluttertoast.dart';
// ignore: depend_on_referenced_packages
import 'package:logger/logger.dart';

import 'lang.dart';

String getErrorMessage(Failure error) {
  if (error is ServerFailure) {
    return kSomthingWentWrong;
  } else if (error is InternetFailure) {
    return kInternetNotAvailable;
  } else if (error is HttpFailure) {
    if (error.errorModel?.message != null) return error.errorModel!.message;
    return error.message;
  } else {
    return kSomthingWentWrong;
  }
}

(String, ErrorDictionary?) getErrorMessageAndDic(Failure error) {
  if (error is ServerFailure) {
    return (kSomthingWentWrong, null);
  } else if (error is InternetFailure) {
    return (kInternetNotAvailable, null);
  } else if (error is HttpFailure) {
    // تحقق من حالة الخطأ 400 (البيانات غير صحيحة)
    if (error.errorModel != null && error.errorModel!.status == 400) {
      if (error.errorModel!.messageDic != null) {
        // تحويل List<MapEntry<String, String?>> إلى Map<String, String?>
        final map = Map<String, String?>.fromEntries(
          error.errorModel!.messageDic!,
        );

        // إنشاء الرسائل المفهومة للمستخدم
        final messages = map.entries
            .map((e) {
              final field = e.key;
              final status = e.value;
              String readableStatus = _translateStatus(status);
              return '$field has $readableStatus';
            })
            .join('\n');

        return (
          messages, // ✅ إرجاع الرسالة المفصلة هنا
          null,
        );
      }
    }

    // fallback: رسالة عامة من الـ errorModel أو من الرسالة النصية
    return (error.errorModel?.message ?? error.message, null);
  } else {
    return ('Unknown error occurred... try again later', null);
  }
}

// دالة مساعدة لترجمة الحالة
String _translateStatus(String? status) {
  switch (status) {
    case 'INVALID_LENGTH':
      return 'INVALID_LENGTH';
    case 'INVALID_FORMAT':
      return 'INVALID_FORMAT';
    default:
      return 'Unknown';
  }
}

void plog(dynamic value) => kDebugMode ? Logger().d(value) : null;
void eplog(dynamic value) => kDebugMode ? Logger().e(value) : null;
void wplog(dynamic value) => kDebugMode ? Logger().w(value) : null;

TimeOfDay parseStringToTime(String time) => TimeOfDay(
  hour: int.parse(time.split(':').first),
  minute: int.parse(time.split(':')[1]),
);

TimeOfDay? dateToTime(DateTime? date) =>
    date == null ? null : TimeOfDay.fromDateTime(date);

TimeOfDay? parseStringToTimeOr(String? time) =>
    time == null
        ? null
        : TimeOfDay(
          hour: int.parse(time.split(':').first),
          minute: int.parse(time.split(':')[1]),
        );

double timeToDouble(TimeOfDay? time) {
  if (time == null) return 0;
  return time.hour + time.minute / 60;
}

DateTime? parseDateOr(String? date) =>
    date == null ? null : DateTime.tryParse(date)?.toLocal();
DateTime parseDate(String date) => DateTime.parse(date).toLocal();
String? dateToString(DateTime? date) => date?.toUtc().toIso8601String();

String formatDate(DateTime date, {String? pattern}) =>
    DateFormat(pattern ?? 'd/M/y').format(date);
String? formatDateOr(DateTime? date, {String? pattern}) =>
    date == null ? null : DateFormat(pattern ?? 'd/M/y').format(date);

String getNameTr(String? nameEn, String? nameAr) =>
    (AppLanguage.isLTR ? nameEn ?? nameAr : nameAr ?? nameEn) ?? '';

showToast({context, required String message, List<String>? args}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message.tr(args: args));
}

showErrorToast({context, required String? message, List<String>? args}) {
  if (message == null || message.isEmpty) return;
  Fluttertoast.cancel();
  Fluttertoast.showToast(msg: message.tr(args: args));
}

void onPaginate(ScrollController scrollController, VoidCallback call) {
  scrollController.addListener(() {
    // final maxPixel = _scrollController.position.maxScrollExtent;
    // final curr = _scrollController.position.pixels;
    // if ((maxPixel - curr).floor() == 0) cubit.getAttendances();
    if (scrollController.position.extentAfter < 100) call();
  });
}

String getDateFormatLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return 'today'.tr();
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'yesterday'.tr();
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}

String translateStatus(String status) {
  switch (status) {
    case 'INVALID_LENGTH':
      return 'Invalid length';
    case 'INVALID_FORMAT':
      return 'INVALID_FORMAT';
    default:
      return status;
  }
}

String getDateFormatStartWithTime(
  DateTime date,
  BuildContext context, {
  bool withYesterdayWord = false,
}) {
  final now = DateTime.now();
  final today = now;
  final yesterday = today.subtract(const Duration(days: 1));

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return TimeOfDay.fromDateTime(date).format(context);
  } else if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return withYesterdayWord
        ? '${'yesterday'.tr()} '
        : TimeOfDay.fromDateTime(date).format(context);
  } else {
    return '${date.day}/${date.month}/${date.year}';
  }
}

///check if there is internet connection berfore execut the function

String? getImageUrl(String? url) {
  if (url == null) return null;
  if (url.startsWith('http')) return url;
  return domain + url;
}

void copyToClipboard(String textToCopy) {
  Clipboard.setData(ClipboardData(text: textToCopy));
  showToast(message: 'copied_to_clipboard');
}
