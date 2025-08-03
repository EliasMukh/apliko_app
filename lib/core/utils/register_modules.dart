// ignore_for_file: curly_braces_in_flow_control_structures, unused_element

import 'dart:io';
import 'package:apliko/core/logical/constaints.dart';
import 'package:apliko/core/utils/extensions.dart';
import 'package:apliko/core/utils/funcs.dart';
import 'package:apliko/core/utils/user_info.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/authentication/domain/repositories/auth_repository.dart';
import '../../../injectable/injecter.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
  @lazySingleton
  Dio get dio =>
      Dio()
        ..options.connectTimeout = 10000.duration
        ..options.receiveTimeout = 10000.duration
        ..options.headers[kUserAgent] = Platform.isIOS ? 'ios' : 'android'
        ..interceptors.add(
          InterceptorsWrapper(
            // onError: (e, handler) {
            //   eplog(e);
            //   handler.next(e);
            // },
            onRequest: (options, handler) async {
              plog(options.uri);
              if (options.data != null &&
                  !options.uri.toString().contains('contact'))
                plog(options.data);

              final String? token = options.headers[kAuthorization]
                  ?.replaceFirst('$kBearer ', '');
              plog(token);
              // if (token != null && isTokenExpired(token))
              // {
              //   final isRefreshed = await _refreshToken(options);
              //   if (!isRefreshed) return;
              // }

              handler.next(options);
            },
            onResponse: (res, handler) {
              plog(res.data);
              handler.next(res);
            },
          ),
        );

  bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } on Exception catch (e) {
      eplog(e);
      return false;
    }
  }

  Future<bool> _refreshToken(options) async {
    final either = await getIt<IAuthRepository>().refreshToken();
    return either.fold((l) => false, (r) {
      options.headers[kAuthorization] = '$kBearer ${UserInfo.user!.token}';
      return true;
    });
  }
}
