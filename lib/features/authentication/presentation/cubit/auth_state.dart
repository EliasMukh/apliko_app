part of 'auth_cubit.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.logout() = _Logout;
  const factory AuthState.updated([String? message]) = _Updated;
  const factory AuthState.error(String message, [ErrorDictionary? errorDic]) = _Error;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.gotProfile(UserModel userModel) = _GotProfile;
  const factory AuthState.gotData(data) = _GotData;
}
