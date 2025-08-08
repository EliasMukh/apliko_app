// ignore_for_file: curly_braces_in_flow_control_structures, await_only_futures

import 'dart:developer';

import 'package:apliko/core/logical/errors/failures.dart'
    show HttpFailure, InternetFailure, ServerFailure;
import 'package:apliko/core/utils/extensions.dart';
import 'package:apliko/core/utils/funcs.dart';
import 'package:apliko/core/utils/user_info.dart';

import 'package:apliko/features/authentication/domain/models/device.dart'
    show DeviceModel;
import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:apliko/core/logical/enums/login_type.dart';
import '../../../../core/logical/errors/error_model.dart';
import '../../domain/models/user.dart';

import '../../domain/models/auth_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/models/recover_password_params.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final IAuthRepository _repo;
  AuthCubit(this._repo) : super(const AuthState.initial());

  void reset() {}

  Future<void> recoverPassword(String email) async {
    emit(const AuthState.loading());
    //!  // 📦 نجهز البيانات في "صندوق"
    final params = RecoverPasswordParams(email: email);
    //!
    //! {email: "ahmed@example.com"} بارامس الآن يحتوي على:

    final either = await _repo.recoverPassword(
      params,
    ); //!  نرسل الصندوق بارامس للريبوسيتيري
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (_) => emit(const AuthState.updated()),
    );
  }

  //!  استقبال و تجهيز البيانات  يتم استقيال البيانات من العميل اي من ال يو أي
  Future<void> submitRecoverPassword(String code, String newPassword) async {
    emit(const AuthState.loading());
    //!📦 نجهز البيانات في صندوق اكبر يحتوي على معلومتين
    final params = SubmitRecoverPasswordParams(
      code: code, //!مثلا 123456
      newPassword: newPassword, //! مثلا MyNewPassword123
    );
    //! params الآن = {code: "123456", newPassword: "MyNewPassword123"}
    //.......................................................
    //! submitRecoverPassword هذا هو العقد
    //! اي الخلاصة اننا في الارسال نستخدم العقد الموجود في الابستراكت لاننا نقوم ب ارسال بارامس امااا في استلام البيانات من العميل نقوم بتجهيز تابع بنفس اسم العقد و نقوم بتجهيزه ل استلام بيانات محددة كما فعلنا في الاعلى
    final either = await _repo.submitRecoverPassword(
      params,
    ); //!🚚  نرسل الصندوق الى الريبوسيتري و سوف نستقبل هذا الصندوق في ريبوسيتوري ايمبليمينت
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (_) => emit(const AuthState.updated()),
    );
  }

  Future<void> tryLoginUser() async {
    emit(const AuthState.loading());

    final isLogin = await _repo.tryAutoLogin();
    if (!isLogin)
      emit(const AuthState.logout());
    else
      emit(const AuthState.authenticated());
  }

  Future<void> loginUser(AuthParams params) async {
    emit(const AuthState.loading());
    final either = await _repo.login(params);
    either.fold(
      (error) {
        log('❌ Login failed: $error');
        emit(AuthState.error(getErrorMessage(error)));
      },
      (user) async {
        log('✅ Login Succesfully: ${user.name}');
        await _repo.cacheUser(user); // 💾 خزّن المستخدم
        UserInfo.user = user;
        emit(const AuthState.authenticated());
      },
    );
  }

  Future<Either<String, String>> getDeviceRegistrationKey(
    String deviceId,
  ) async {
    try {
      final either = await _repo.getDeviceRegistrationKey(deviceId);
      return either.fold(
        (error) {
          log('❌ Error fetching device registration key: $error');
          emit(AuthState.error(getErrorMessage(error)));
          return Left(getErrorMessage(error));
        },
        (key) {
          log('✅ Device registration key fetched successfully');
          return Right(key);
        },
      );
    } catch (e) {
      log('❌ Exception when fetching device registration key: $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> grantDeviceAccess(
    String deviceId,
    String email,
    String rights,
  ) async {
    try {
      log(
        '🔄 Starting grantDeviceAccess - deviceId: $deviceId, email: $email, rights: $rights',
      );

      final either = await _repo.grantDeviceAccess(deviceId, email, rights);
      return either.fold(
        (error) {
          log('❌ Error granting device access: $error');
          emit(AuthState.error(getErrorMessage(error)));
          return Left(getErrorMessage(error));
        },
        (success) {
          log('✅ Device access granted successfully');
          return Right(success);
        },
      );
    } catch (e) {
      log('❌ Exception when granting device access: $e');
      log('❌ Exception type: ${e.runtimeType}');

      // معالجة مختلفة حسب نوع الخطأ
      String errorMessage;
      if (e is NoSuchMethodError) {
        log('❌ NoSuchMethodError details: ${e.toString()}');
        errorMessage = 'System error occurred. Please try again later.';
      } else if (e is TypeError) {
        log('❌ TypeError details: ${e.toString()}');
        errorMessage = 'Data format error. Please contact support.';
      } else {
        errorMessage = 'An unexpected error occurred: ${e.toString()}';
      }

      emit(AuthState.error(errorMessage));
      return Left(errorMessage);
    }
  }

  Future<List<DeviceModel>> getDevices() async {
    final either = await _repo.getDevices();
    return either.fold(
      (error) {
        log('Error in fetching devices $error');
        emit(AuthState.error(getErrorMessage(error)));
        return [];
      },
      (deviceListJson) {
        final devices =
            deviceListJson
                .map<DeviceModel>((json) => DeviceModel.fromJson(json))
                .toList();
        log('✅   ]Device ${devices.length} fetched');
        return devices;
      },
    );
  }

  Future<DeviceModel> addDevice(DeviceModel deviceModel) async {
    final either = await _repo.addDevice(deviceModel);
    return either.fold(
      (error) {
        log('❌ Error in fetched device: $error');
        emit(AuthState.error(getErrorMessage(error)));
        throw Exception(error);
      },
      (deviceData) {
        log('✅   device fetched: ${deviceModel.name}');
        return deviceData;
      },
    );
  }

  Future<Either<String, Map<String, dynamic>?>> getSupersetLink(
    String deviceId,
  ) async {
    try {
      final either = await _repo.getSupersetDashboardLink(deviceId);
      return either.fold(
        (error) {
          log('❌ Error fetching Superset link: $error');
          emit(AuthState.error(getErrorMessage(error)));
          return Left(getErrorMessage(error));
        },
        (data) {
          log('✅ Superset link fetched successfully');
          return Right(data);
        },
      );
    } catch (e) {
      log('❌ Exception when fetching Superset link: $e');
      return Left(e.toString());
    }
  }

  Future<void> loginUserSocial(LoginSocialType type) async {
    emit(const AuthState.loading());
    final either = await _repo.loginSocial(type);
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (user) async => emit(const AuthState.authenticated()),
    );
  }

  Future<void> updateProfile(UserModel newUserModel) async {
    emit(const AuthState.loading());
    final either = await _repo.updateProfile(newUserModel);
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (_) => emit(const AuthState.updated()),
    );
  }

  Future<void> register(AuthParams params) async {
    emit(const AuthState.loading());
    final either = await _repo.register(params);
    either.fold(
      (error) {
        if (error is HttpFailure) {
          final errorMessages = error.errors?.entries
              .map((e) => '${e.key} has ${_translateStatus(e.value)}')
              .join('\n');
          emit(AuthState.error('${error.message}\n$errorMessages'));
        } else if (error is ServerFailure) {
          emit(AuthState.error('Server failure occurred.'));
        } else if (error is InternetFailure) {
          emit(AuthState.error('Internet connection error.'));
        } else {
          emit(AuthState.error('Unknown error occurred.'));
        }
      },
      (user) async {
        await _repo.cacheUser(user);
        UserInfo.user = user;
        emit(const AuthState.authenticated());
        plog("اسم المستخدم من السيرفر: ${user.name}");
      },
    );
  }

  String _translateStatus(String status) {
    switch (status) {
      case 'INVALID_LENGTH':
        return 'Invalid Length';
      case 'INVALID_FORMAT':
        return 'Invalid Format';
      default:
        return 'Unknown Error';
    }
  }

  Future<void> logout() async {
    emit(const AuthState.loading());
    final either = await _repo.logout();
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (user) => emit(const AuthState.logout()),
    );
  }

  Future<bool> refreshToken() async {
    final either = await _repo.refreshToken();
    return either.fold((l) => false, (r) => true);
  }

  Future<void> getProfile() async {
    emit(const AuthState.loading());
    final either = await _repo.getProfile();
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (user) => emit(AuthState.gotProfile(user)),
    );
  }

  Future<void> resendEmailVerification(
    AuthParams params,
    Function(String) onRes,
  ) async {
    final either = await _repo.resendEmail(params);
    either.fold(
      (error) => onRes(getErrorMessage(error)),
      (_) => onRes('email has been resent successfully'),
    );
  }

  void resetPassword(String email) async {
    emit(const AuthState.loading());
    final either = await _repo.resetPassword(email);
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (_) => emit(const AuthState.updated()),
    );
  }

  void uploadProfileImage(String path) async {
    emit(const AuthState.loading());
    final either = await _repo.uploadImage(path);
    either.fold(
      (error) => emit(AuthState.error(getErrorMessage(error))),
      (_) => getProfile(),
    );
  }

  void emitGotProfile() async {
    emit(const AuthState.loading());
    await Future.delayed(1.duration);
    emit(AuthState.gotProfile(UserInfo.user!));
  }
}
//test