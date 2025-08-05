// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:apliko/features/authentication/domain/models/device.dart'
    as _i9;
import 'package:apliko/features/authentication/presentation/pages/DeviceDetailsPage.dart'
    as _i1;
import 'package:apliko/features/authentication/presentation/pages/forget_password.dart'
    as _i2;
import 'package:apliko/features/authentication/presentation/pages/home_page.dart'
    as _i3;
import 'package:apliko/features/authentication/presentation/pages/login_page.dart'
    as _i5;
import 'package:apliko/features/authentication/presentation/pages/submit_recover_password.dart'
    as _i6;
import 'package:apliko/init_page.dart' as _i4;
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;

/// generated route for
/// [_i1.DeviceDetailsPage]
class DeviceDetailsRoute extends _i7.PageRouteInfo<DeviceDetailsRouteArgs> {
  DeviceDetailsRoute({
    _i8.Key? key,
    required _i9.DeviceModel device,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         DeviceDetailsRoute.name,
         args: DeviceDetailsRouteArgs(key: key, device: device),
         initialChildren: children,
       );

  static const String name = 'DeviceDetailsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeviceDetailsRouteArgs>();
      return _i1.DeviceDetailsPage(key: args.key, device: args.device);
    },
  );
}

class DeviceDetailsRouteArgs {
  const DeviceDetailsRouteArgs({this.key, required this.device});

  final _i8.Key? key;

  final _i9.DeviceModel device;

  @override
  String toString() {
    return 'DeviceDetailsRouteArgs{key: $key, device: $device}';
  }
}

/// generated route for
/// [_i2.ForgetPasswordPage]
class ForgetPasswordRoute extends _i7.PageRouteInfo<void> {
  const ForgetPasswordRoute({List<_i7.PageRouteInfo>? children})
    : super(ForgetPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgetPasswordRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i2.ForgetPasswordPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.InitPage]
class InitRoute extends _i7.PageRouteInfo<void> {
  const InitRoute({List<_i7.PageRouteInfo>? children})
    : super(InitRoute.name, initialChildren: children);

  static const String name = 'InitRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i4.InitPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i7.PageRouteInfo<void> {
  const LoginRoute({List<_i7.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.SubmitRecoverPasswordPage]
class SubmitRecoverPasswordRoute extends _i7.PageRouteInfo<void> {
  const SubmitRecoverPasswordRoute({List<_i7.PageRouteInfo>? children})
    : super(SubmitRecoverPasswordRoute.name, initialChildren: children);

  static const String name = 'SubmitRecoverPasswordRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return _i6.SubmitRecoverPasswordPage();
    },
  );
}
