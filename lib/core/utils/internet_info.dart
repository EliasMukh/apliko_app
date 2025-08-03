import 'dart:ui';

import 'package:aplico/core/logical/constaints.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'funcs.dart';

class InternetInfo {
  static final internetConnection =
      InternetConnection()
        ..onStatusChange.listen((InternetStatus status) {
          isConnect = switch (status) {
            InternetStatus.connected => true,
            _ => false,
          };
        });

  static Future<bool> get initState async =>
      internetConnection.hasInternetAccess;
  static bool isConnect = true;

  static bool get isDisconnect {
    if (isConnect) return false;
    showErrorToast(message: kInternetNotAvailable);
    return true;
  }

  void checkInternet(VoidCallback call) {
    if (InternetInfo.isDisconnect) return;
    call();
  }
}
