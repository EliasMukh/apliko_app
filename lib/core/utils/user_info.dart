import '../../../features/authentication/domain/models/user.dart';

/// current user info
abstract class UserInfo {
  static UserModel? user;

  static String get id => user!.id;

  static initUser(UserModel userModel) {
    user = userModel;
  }

  static void clear() {
    user = null;
  }
}
