// ignore_for_file: use_build_context_synchronously

import 'package:apliko/core/logical/constaints.dart';
import 'package:apliko/core/utils/funcs.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();
  static LocationService? _location;
  static LocationService get instance {
    _location ??= LocationService._();
    return _location!;
  }

  Position? po;

  Future<Position?> getLastLocation() async {
    if (po != null) return po;
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getLastKnownPosition();
      return position;
    } catch (e) {
      eplog(e);
      return null;
    }
  }

  Future<Position?> determinePosition({
    String rejectMessage = kLocationError,
    BuildContext? context,
  }) async {
    LocationPermission permission;

    // Test if location services are enabled.
    // final locStream = Geolocator.getServiceStatusStream().listen();

    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   if (openSettingM != null) showErrorToast(message: openSettingM);
    //   await Geolocator.openLocationSettings();
    //   return null;
    // }
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          showErrorToast(message: rejectMessage, context: context);
          return null;
        }
      }

      po = await Geolocator.getCurrentPosition();
      return po;
    } catch (_) {
      showErrorToast(message: rejectMessage, context: context);
    }
    return null;
  }
}
