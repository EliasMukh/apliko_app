import 'dart:developer' show log;

import 'package:apliko/core/utils/funcs.dart';
import 'package:apliko/core/utils/user_info.dart';
import 'package:dio/dio.dart';

import 'package:injectable/injectable.dart';
import 'package:apliko/core/logical/enums/login_type.dart';
import '../../../../core/logical/urls.dart';
import '../../domain/models/auth_params.dart';
import '../../domain/models/user.dart';
import '../../domain/models/device.dart';
import '../../domain/models/recover_password_params.dart';

abstract class IAuthRemoteDS {
  //! 📋 عقد آخر: "يجب أن تستقبل بارامس وترجع Future<bool>"
  Future<bool> recoverPassword(RecoverPasswordParams params);
  Future<bool> submitRecoverPassword(SubmitRecoverPasswordParams params);

  Future<String> getDeviceRegistrationKey(String deviceId);
  Future<UserModel> loginUser(AuthParams params);
  Future<UserModel> register(AuthParams params);
  Future<UserModel> loginUserSocial(LoginSocialType type);
  Future<bool> logout();
  Future<bool> resetPassword(String email);
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile(UserModel newUserModel);
  Future<Map> uploadImage(String path);
  Future<bool> changeEmail(AuthParams params);
  Future<bool> changePassword(AuthParams params);
  Future<bool> resendEmail(AuthParams params);
  Future refreshToken();
  Future<Map<String, dynamic>> getSupersetDashboardLink(String deviceId);
  // New device methods
  Future<List<DeviceModel>> getDevices();
  Future<DeviceModel> addDevice(String name, String description);
  // إضافة هذا السطر في abstract class IAuthRemoteDS
  Future<bool> grantDeviceAccess(String deviceId, String email, String rights);
}

@LazySingleton(as: IAuthRemoteDS)
class AuthRemoteDataSourceImpl extends IAuthRemoteDS {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  //! // يأخذ البيانات ويرسلها للسيرفر
  //!   📨 ريموتدس استقبل نفس الصندوق
  //! // params = RecoverPasswordParams(email: "ahmed@example.com")
  Future<bool> recoverPassword(RecoverPasswordParams params) async {
    try {
      //! 📤 نفتح الصندوق ونرسل محتواه للسيرفر
      final response = await dio.post(
        recoverPasswordUrl,
        data: params.toJson(),
      );

      return response.statusCode == 200; //!    ✅ نتحقق من رد السيرفر
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw AuthException(message: 'User not found');
      } else if (e.response?.statusCode == 409) {
        throw AuthException(message: 'Recovery error occurred');
      }
      throw AuthException(
        message: 'Error requesting password recovery: ${e.message}',
      );
    } catch (e) {
      throw AuthException(message: 'Error requesting password recovery: $e');
    }
  }

  @override
  //! بستقبل بارامس من ريبوسيتوري
  Future<bool> submitRecoverPassword(SubmitRecoverPasswordParams params) async {
    try {
      //! يرسل جيسون الى السيرفر
      final response = await dio.post(
        submitRecoverPasswordUrl,
        data: params.toJson(),
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw AuthException(message: 'Invalid request');
      } else if (e.response?.statusCode == 404) {
        throw AuthException(message: 'Code not found');
      }
      throw AuthException(
        message: 'Error submitting password recovery: ${e.message}',
      );
    } catch (e) {
      throw AuthException(message: 'Error submitting password recovery: $e');
    }
  }

  @override
  Future<UserModel> loginUser(AuthParams params) async {
    final response = await dio.post(loginUrl, data: params.toJson());
    final data = response.data;
    plog('📦 Response data: $data');
    return UserModel.fromJson(data);
  }

  @override
  Future<bool> logout() async {
    try {} on Exception catch (_) {}
    return true;
  }

  @override
  Future<UserModel> register(AuthParams params) async {
    try {
      final response = await dio.post(registerUrl, data: params.toJson());
      final data = response.data;
      plog('📦 Response data: $data');
      return UserModel.fromJson(data);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data is Map) {
        final Map<String, dynamic> errorData = e.response?.data;
        // ignore: avoid_print
        print('Error data: $errorData'); // طباعة بيانات الخطأ

        final String status =
            errorData['status'] ?? 'An error occurred during registration';
        final Map<String, String> errors = {};

        // تحقق مما إذا كانت الرسالة تشير إلى أن الحساب موجود مسبقًا
        if (status == 'User with that email already exists') {
          throw AuthException(
            message: 'Account already exists',
            errors: errors,
          );
        }

        // معالجة الأخطاء الأخرى
        errorData.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errors[key] = value.first;
          }
        });

        throw AuthException(message: status, errors: errors);
      } else {
        throw AuthException(message: 'An unexpected error occurred');
      }
    } catch (e) {
      throw AuthException(message: 'An error occurred during registration');
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final res = await dio.get(profileUrl);
      final data = (res.data as List)[0];

      final userModel = UserModel.fromJson(data);
      return userModel;
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel newUserModel) async {
    try {
      await dio.patch(
        '$profileUrl${UserInfo.user!.id}/',
        data: newUserModel.toJson(),
      );
      return newUserModel;
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }

  @override
  Future<bool> changeEmail(AuthParams params) async {
    return true;
  }

  @override
  Future<bool> changePassword(AuthParams params) async {
    return true;
  }

  @override
  Future<bool> resendEmail(AuthParams params) async {
    return true;
  }

  @override
  Future refreshToken() async {}

  @override
  Future<UserModel> loginUserSocial(LoginSocialType type) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> resetPassword(String email) async {
    return true;
  }

  @override
  Future<Map> uploadImage(String path) async {
    try {
      // final formData = FormData.fromMap({
      //   'image': await MultipartFile.fromFile(path),
      // });
      // final res = await dio.post(profileImageUrl, data: formData);
      // return res.data;
      throw UnimplementedError();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // New device methods implementation

  @override
  Future<List<DeviceModel>> getDevices() async {
    try {
      //! ارسال غيت ريكويست للسيرفر
      final response = await dio.get(getDevicesUrl);
      //!                         ^^^^^^^^^^^^^
      //!  'https://api.notiot.ru/api/devices'

      //!          await تعني انتظار حتى يرد السيرفر
      //!          response يحتوي على رد السيرفر

      if (response.statusCode == 200) {
        //! 📥 استقبال البيانات من السيرفر
        final List<dynamic> jsonList = response.data;

        //! 🔄 تحويل واحد فقط: JSON → DeviceModel
        final devices =
            jsonList
                .map<DeviceModel>((json) => DeviceModel.fromJson(json))
                .toList();

        log('🌐 Received ${devices.length} devices from server');
        return devices;
      } else {
        throw AuthException(
          message: 'Failed to fetch devices: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw AuthException(message: 'Devices endpoint not found');
      } else if (e.response?.statusCode == 500) {
        throw AuthException(message: 'Server error occurred');
      }
      throw AuthException(message: 'Network error: ${e.message}');
    } catch (e) {
      throw AuthException(message: 'Unexpected error: $e');
    }
  }

  /*
///! jsonList = [JSON1, JSON2, JSON3]

///! .map() تعمل على كل عنصر:
///! العنصر الأول:
///! json = {"id": "1", "name": "Smart TV", "status": "online"}
///! DeviceModel.fromJson(json) → DeviceModel(id: "1", name: "Smart TV", status: "online")

///! العنصر الثاني:  
///! json = {"id": "2", "name": "AC Unit", "status": "offline"}
///! DeviceModel.fromJson(json) → DeviceModel(id: "2", name: "AC Unit", status: "offline")

///! وهكذا لكل عنصر...

///! .toList() تحول النتيجة إلى List<DeviceModel>
*/
  @override
  Future<Map<String, dynamic>> getSupersetDashboardLink(String deviceId) async {
    try {
      final response = await dio.get(supersetDashboardLinkUrl);
      final data = response.data;
      plog(
        '📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦📦 Response data: $data',
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException(
          message: 'Authentication failed. Please login again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw AuthException(message: 'Device not found or not accessible.');
      }
      throw AuthException(message: 'Error getting Superset link: ${e.message}');
    } catch (e) {
      throw AuthException(message: 'Error getting Superset link: $e');
    }
  }

  @override
  Future<String> getDeviceRegistrationKey(String deviceId) async {
    try {
      final response = await dio.get('$getDeviceRegKeyUrl/$deviceId/regkey');
      final data = response.data;
      return data['key'] as String;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException(
          message: 'Authentication failed. Please login again.',
        );
      } else if (e.response?.statusCode == 404) {
        throw AuthException(
          message:
              'Device not found or you don\'t have permission to access this device.',
        );
      }
      throw AuthException(
        message: 'Error getting registration key: ${e.message}',
      );
    } catch (e) {
      throw AuthException(message: 'Error getting registration key: $e');
    }
  }

  // في AuthRemoteDataSourceImpl
  @override
  Future<bool> grantDeviceAccess(
    String deviceId,
    String email,
    String rights,
  ) async {
    try {
      plog('🔍 === GRANT DEVICE ACCESS DEBUG ===');
      plog('🔍 Device ID: "$deviceId"');
      plog('🔍 Email: "$email"');
      plog('🔍 Rights: "$rights"');

      final response = await dio.post(
        '$grantDeviceAccessUrl/$deviceId/newuser',
        data: {'email': email, 'rights': rights},
      );

      plog('✅ Response Status: ${response.statusCode}');
      plog('✅ Response Data: ${response.data}');

      // التحقق من وجود البيانات قبل الوصول إليها
      if (response.data != null) {
        plog('✅ Response data is not null');

        // إذا كان response.data يحتوي على session_id
        if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('session_id')) {
            plog('✅ Session ID found: ${responseMap['session_id']}');
          } else {
            plog('⚠️ No session_id in response');
          }
        }
      } else {
        plog('⚠️ Response data is null');
      }

      return response.statusCode == 200;
    } on DioException catch (e) {
      plog('❌ === DETAILED ERROR DEBUG ===');
      plog('❌ Status Code: ${e.response?.statusCode}');
      plog('❌ Response Data: ${e.response?.data}');
      plog('❌ Request Data: ${e.requestOptions.data}');
      plog('❌ Request URL: ${e.requestOptions.uri}');

      // التحقق من البيانات قبل الوصول إليها
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        if (errorData is Map<String, dynamic> &&
            errorData.containsKey('status')) {
          throw Exception(errorData['status']);
        }
      }

      rethrow;
    } catch (e) {
      plog('❌ Exception: $e');
      plog('❌ Exception type: ${e.runtimeType}');
      rethrow;
    }
  }

  @override
  Future<DeviceModel> addDevice(String name, String description) async {
    try {
      final response = await dio.post(
        addDeviceUrl,
        data: {'name': name, 'description': description},
      );

      if (response.statusCode == 201) {
        // Since the API returns 201 without device data, we'll fetch the latest devices
        final devicesResponse = await dio.get(getDevicesUrl);
        final devicesData = devicesResponse.data;

        if (devicesData is Map && devicesData.containsKey('devices')) {
          final devices =
              (devicesData['devices'] as List)
                  .map((json) => DeviceModel.fromJson(json))
                  .toList();

          // Find the newly added device (should be the last one)
          if (devices.isNotEmpty) {
            final newDevice = devices.firstWhere(
              (device) =>
                  device.name == name && device.description == description,
              orElse:
                  () => DeviceModel(
                    id: '',
                    name: name,
                    description: description,
                    status: 'pending',
                    params: {},
                    userAccessLevel: '',
                  ),
            );
            return newDevice;
          }
        }

        // Fallback if we can't find the device
        return DeviceModel(
          id: '',
          name: name,
          description: description,
          status: 'pending',
          params: {},
          userAccessLevel: '',
        );
      }

      throw AuthException(
        message: 'Failed to add device. Status: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AuthException(
          message: 'Authentication failed. Please login again.',
        );
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        throw AuthException(
          message: errorData['status'] ?? 'Invalid device data provided',
        );
      }
      throw AuthException(message: 'Error adding device: ${e.message}');
    } catch (e) {
      throw AuthException(message: 'Error adding device: $e');
    }
  }
}

class AuthException implements Exception {
  final String message;
  final Map<String, String> errors;

  AuthException({required this.message, this.errors = const {}});

  @override
  String toString() => message;
}
