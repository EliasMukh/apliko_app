import 'package:apliko/core/logical/abstract/models.dart';
import 'package:apliko/core/logical/enums/login_type.dart';
import 'package:apliko/features/authentication/domain/models/device.dart';

import '../models/auth_params.dart';
import '../models/user.dart';
import '../models/recover_password_params.dart';

abstract class IAuthRepository {
  //!هذا مجرد "عقد" يقول: "يجب أن تستقبل بارامس وترجع FutureEither<bool>"
  FutureEither<bool> recoverPassword(RecoverPasswordParams params);
  //! العقد يقول يجب ان نستلم بارامس من نوع
  FutureEither<bool> submitRecoverPassword(SubmitRecoverPasswordParams params);

  FutureEither<String> getDeviceRegistrationKey(String deviceId);
  FutureEither<Map<String, dynamic>> getSupersetDashboardLink(String deviceId);
  FutureEither<UserModel> login(AuthParams params);
  FutureEither<UserModel> loginSocial(LoginSocialType type);
  FutureEither<UserModel> register(AuthParams params);
  FutureEither<DeviceModel> addDevice(DeviceModel params);

  //! هذا العقد لا يحتاج الى معاملات يستقبلها
  FutureEither<List<DeviceModel>> getDevices();//////////////////////////////////////////////////////////////////////////////////////////

  FutureEither<bool> refreshToken();
  FutureEither<UserModel> updateProfile(UserModel newUserModel);
  FutureEither<Map> uploadImage(String path);
  FutureEither<UserModel> getProfile();
  FutureEither<bool> changePassword(AuthParams params);
  FutureEither<bool> changeEmail(AuthParams params);
  FutureEither<bool> resendEmail(AuthParams params);
  FutureEither<bool> resetPassword(String email);
  FutureEither<bool> logout();
  bool tryAutoLogin();
  // إضافة هذا السطر في abstract class IAuthRepository
  FutureEither<bool> grantDeviceAccess(
    String deviceId,
    String email,
    String rights,
  );
  Future<void> cacheUser(UserModel user);
  FutureEither<UserModel> getCachedUser();
}
