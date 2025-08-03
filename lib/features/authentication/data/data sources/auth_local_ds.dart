import 'dart:convert';

import 'package:apliko/core/utils/funcs.dart';
import 'package:apliko/core/utils/lang.dart';
import 'package:apliko/core/utils/user_info.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/logical/constaints.dart';
import '../../../../injectable/injecter.dart';
import '../../domain/models/user.dart';

abstract class IAuthLocalDS {
  Future<bool> cacheUser(UserModel userModel);
  Future<bool> logout();
  bool tryAutoLoginUser();

  Future<void> updateProfile(UserModel newUserModel);

  Future updateToken(token);
}

@LazySingleton(as: IAuthLocalDS)
class AuthLocalDSImpl extends IAuthLocalDS {
  final SharedPreferences _sharedPreferences;

  AuthLocalDSImpl(this._sharedPreferences);

  @override
  Future<bool> cacheUser(UserModel userModel) async {
    await _sharedPreferences.setString(
      kUserInfo,
      jsonEncode(userModel.toJson()),
    );
    UserInfo.initUser(userModel);
    configDio();
    return true;
  }

  /// UserInfo need to be initialized first
  void configDio() {
    getIt<Dio>().options.headers[kAuthorization] =
        '$kBearer ${UserInfo.user?.token}';
    getIt<Dio>().options.headers[kLanguage] = AppLanguage.isLTR ? 'en' : 'ar';
  }

  @override
  Future<bool> logout() async {
    await _sharedPreferences.clear();
    getIt<Dio>().options.headers.remove(kAuthorization);
    UserInfo.clear();
    return true;
  }

  @override
  bool tryAutoLoginUser() {
    plog('try in ds');
    if (!_sharedPreferences.containsKey(kUserInfo)) return false;
    final data = _sharedPreferences.getString(kUserInfo);

    if (data == null) return false;

    final map = jsonDecode(data);
    plog(map);

    final userModel = UserModel.fromJson(map);
    UserInfo.initUser(userModel);
    configDio();
    return true;
  }

  @override
  Future<void> updateProfile(UserModel newUserModel) async {
    var userModel = UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(kUserInfo)!),
    );
    newUserModel.token ??= userModel.token;
    newUserModel.refreshToken ??= userModel.refreshToken;
    newUserModel.fcmToken ??= userModel.fcmToken;
    userModel = newUserModel;
    // plog('new model data: ${userModel.toJson()}');
    UserInfo.initUser(userModel);
    await _sharedPreferences.setString(
      kUserInfo,
      jsonEncode(userModel.toJson()),
    );
  }

  @override
  Future updateToken(token) async {
    final userModel = UserModel.fromJson(
      jsonDecode(_sharedPreferences.getString(kUserInfo)!),
    );
    userModel.token = token;
    UserInfo.initUser(userModel);
    configDio();
    await _sharedPreferences.setString(
      kUserInfo,
      jsonEncode(userModel.toJson()),
    );
  }
}
