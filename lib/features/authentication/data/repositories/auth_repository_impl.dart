import 'dart:convert';
import 'dart:developer';

import 'package:apliko/features/authentication/domain/models/device.dart';
import 'package:apliko/features/authentication/domain/models/recover_password_params.dart';
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:injectable/injectable.dart';
import 'package:apliko/core/logical/abstract/models.dart';
import 'package:apliko/core/logical/enums/login_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/logical/abstract/repository_mixin.dart';
import '../../../../core/logical/errors/failures.dart';
import '../../domain/models/auth_params.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data sources/auth_remote_ds.dart';
import '../data%20sources/auth_local_ds.dart';

@LazySingleton(as: IAuthRepository)
class AuthRepoImpl extends IAuthRepository {
  final IAuthRemoteDS _remoteDS;
  final IAuthLocalDS _localDS;

  AuthRepoImpl(this._remoteDS, this._localDS);

  @override
  //! 📨 ريبوسيتوري يستقبل الصندوق بارامس من كيوبت
  //! params = RecoverPasswordParams(email: "ahmed@example.com")
  FutureEither<bool> recoverPassword(RecoverPasswordParams params) {
    return sendRequest(
      () => _remoteDS.recoverPassword(params),
    ); //! (بارامس) النادل ريموتدس يمرر نفس الطلب
  }

  @override
  Future<Either<Failure, UserModel>> login(AuthParams params) async {
    return sendRequest<UserModel>(
      () => _remoteDS.loginUser(params),
      cacheCall: _localDS.cacheUser,
    );
  }

  @override
  bool tryAutoLogin() {
    return _localDS.tryAutoLoginUser();
  }

  @override
  //! 📥 يستقبل بارامس من كيوبت
  FutureEither<bool> submitRecoverPassword(SubmitRecoverPasswordParams params) {
    //! يرسل بارامس الى ريموتدس
    return sendRequest(() => _remoteDS.submitRecoverPassword(params));
  }

  @override
  Future<Either<Failure, bool>> logout() {
    return sendRequest<bool>(
      () => _remoteDS.logout(),
      cacheCall: (_) => _localDS.logout(),
    );
  }

  @override
  Future<Either<Failure, UserModel>> register(AuthParams params) {
    return sendRequest<UserModel>(
      () => _remoteDS.register(params),
      cacheCall: _localDS.cacheUser,
    );
  }

  @override
  Future<Either<Failure, UserModel>> getProfile() {
    return sendRequest<UserModel>(
      () => _remoteDS.getProfile(),
      cacheCall: (userModel) async {
        await _localDS.updateProfile(userModel);
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(UserModel newUserModel) {
    return sendRequest<UserModel>(
      () => _remoteDS.updateProfile(newUserModel),
      cacheCall: _localDS.updateProfile,
    );
  }

  @override
  Future<Either<Failure, bool>> changeEmail(AuthParams params) {
    return sendRequest(
      () => _remoteDS.changeEmail(params),
      // cacheCall: _localDS.updateProfile,
    );
  }

  @override
  Future<Either<Failure, bool>> changePassword(AuthParams params) {
    return sendRequest(() => _remoteDS.changePassword(params));
  }

  @override
  Future<Either<Failure, bool>> resendEmail(AuthParams params) {
    return sendRequest(() => _remoteDS.resendEmail(params));
  }

  @override
  Future<Either<Failure, bool>> refreshToken() {
    return sendRequest(() async {
      final res = await _remoteDS.refreshToken();
      await _localDS.updateToken(res);
      return true;
    });
  }

  @override
  Future<Either<Failure, UserModel>> loginSocial(LoginSocialType type) {
    return sendRequest(
      () => _remoteDS.loginUserSocial(type),
      cacheCall: _localDS.cacheUser,
    );
  }

  @override
  FutureEither<bool> resetPassword(String email) {
    return sendRequest(() => _remoteDS.resetPassword(email));
  }

  @override
  FutureEither<Map> uploadImage(String path) {
    return sendRequest(() => _remoteDS.uploadImage(path));
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  @override
  FutureEither<UserModel> getCachedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('user');
      if (jsonString == null) return Left(Failure());
      final jsonMap = jsonDecode(jsonString);
      final user = UserModel.fromJson(jsonMap);
      return Right(user);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  FutureEither<DeviceModel> addDevice(DeviceModel params) {
    return sendRequest<DeviceModel>(
      () => _remoteDS.addDevice(params.name, params.description),
    );
  }

  @override
  FutureEither<List<DeviceModel>> getDevices() {
    // ✅ بساطة! مجرد تمرير بدون تحويلات
    return sendRequest<List<DeviceModel>>(() => _remoteDS.getDevices());
  }

  @override
  FutureEither<Map<String, dynamic>> getSupersetDashboardLink(String deviceId) {
    return sendRequest<Map<String, dynamic>>(
      () => _remoteDS.getSupersetDashboardLink(deviceId),
    );
  }

  @override
  FutureEither<String> getDeviceRegistrationKey(String deviceId) {
    return sendRequest<String>(
      () => _remoteDS.getDeviceRegistrationKey(deviceId),
    );
  }

  // إضافة هذا السطر في abstract class IAuthRepository
  @override
  FutureEither<bool> grantDeviceAccess(
    String deviceId,
    String email,
    String rights,
  ) {
    log(
      '🔄 AuthRepoImpl.grantDeviceAccess - deviceId: $deviceId, email: $email, rights: $rights',
    );
    return sendRequest<bool>(
      () => _remoteDS.grantDeviceAccess(deviceId, email, rights),
    );
  }
}





//! 🔹 HomePage (initState)
//!         |
//!         v
//! 🔹 _fetchDevices()
//!         |
//!         v
//! final devices = await context.read<AuthCubit>().getDevices()
//!         |
//!         v
//! 🔹 AuthCubit.getDevices()
//!         |
//!         v
//! final either = await _repo.getDevices()
//!         |
//!         v
//! 🔹 AuthRepoImpl.getDevices()
//!         |
//!         v
//! return sendRequest(() => _remoteDS.getDevices())
//!         |
//!         v
//! 🔹 sendRequest<T>(...)
//!         |
//!         v
//! await _remoteDS.getDevices()
//!         |
//!         v
//! 🔹 AuthRemoteDS.getDevices()
//!         |
//!         v
//! 🌍 API Server (يرجع JSON بالـ Devices)
//!         |
//!         v
//! 🔹 sendRequest يرجع Either<Failure, List<DeviceModel>>
//!         |
//!         v
//! 🔹 AuthRepoImpl.getDevices() يرجع نفس الـ Either
//!         |
//!         v
//! 🔹 AuthCubit.getDevices() يحول النتيجة → List<DeviceModel> أو []
//!         |
//!         v
//! 🔹 _fetchDevices() يحفظ القائمة في _devices و يعمل setState()
//!         |
//!         v
//! ✅ واجهة HomePage تتحدث وتعرض الأجهزة
