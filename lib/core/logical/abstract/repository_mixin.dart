import 'package:apliko/core/utils/funcs.dart';
import 'package:apliko/core/utils/internet_info.dart';
import 'package:apliko/features/authentication/data/data%20sources/auth_remote_ds.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../errors/error_model.dart';
import '../errors/failures.dart';

//!الـ Generic <T>
//! <T> يعني: "النوع الذي أعمل معه سيكون متغيرًا".

//! مثال:
//!
//! نريد جلب قائمة أجهزة → T = List<DeviceModel>
//!
//! نريد جلب مستخدم واحد → T = User
//!
//! الفكرة: لا نحتاج كتابة دالة مختلفة لكل نوع بيانات.

//! نوع الإرجاع
//! Future<Either<Failure, T>>
//! Future → العملية غير متزامنة، أي تحتاج await.

//! Either<Failure, T> → النتيجة يمكن أن تكون:

//! Right(T) = نجاح → البيانات موجودة

//! Left(Failure) = فشل → حدث خطأ
Future<Either<Failure, T>> sendRequest<T>(
  //! تمرير دالة كمعامل
  //! Future<T> Function() call
  //! هنا نمرر دالة أخرى إلى sendRequest.

  //! الدالة المرسلة تقوم بالطلب الفعلي (مثلاً _remoteDS.getDevices()).

  //! الفائدة:

  //! sendRequest لن يعرف ما هو نوع البيانات أو كيف تحصل عليها.

  //! كل ما عليه فعله: "نفذ الدالة، انتظر النتيجة، عالج الأخطاء"

  /*
/   //!مثال صغير:
Future<int> getNumber() async {
  return 42;
}

Future<void> run() async {
  final result = await sendRequest<int>(() => getNumber());
  print(result);
}
*/

  //!  المعاملات الاختيارية {}
  //! {
  //!   Function(T)? cacheCall,
  //!   bool checkToRevokSession = true
  //! }
  //! الأقواس {} تعني Named Parameters → يمكن تمريرها بالاسم أو تجاهلها.

  //! cacheCall → دالة اختيارية، لتخزين البيانات بعد نجاح الطلب.

  //! checkToRevokSession → قيمة افتراضية، تتحكم بسلوك الخطأ 401.
  Future<T> Function() call, {
  Function(T)? cacheCall,
  bool checkToRevokSession = true,
}) async {
  if (InternetInfo.isConnect) {
    try {
      final T result = await call();

      await cacheCall?.call(result);

      return Right(result);
    } on DioException catch (e) {
      eplog(e);
      eplog(e.response?.data);
      // eplog(e.response?.statusCode);
      if (e.type.name.contains('Timeout') ||
          (e.response?.statusCode ?? 0) >= 500) {
        return Left(ServerFailure());
      } else if ((e.response?.statusCode ?? 0) == 401 && checkToRevokSession) {
        return Left(ServerFailure());
      }
      ErrorModel? errorModel;
      if (e.response?.data != null &&
          e.response!.data is Map &&
          e.response!.data['meta'] != null) {
        try {
          errorModel = ErrorModel.fromJson(e.response!.data['meta']);
        } on Exception catch (_) {}
      }

      if (e.response?.data is Map &&
          e.response?.data["data"]["session_id"] != null) {
        Map<String, dynamic> data = e.response?.data;
        return Left(HttpFailure('already_logged_in', data: data["data"]));
      }
      return Left(
        HttpFailure(
          errorModel != null ? errorModel.message : e.message ?? '',
          errorModel: errorModel,
        ),
      );
    } on AuthException catch (e) {
      return Left(HttpFailure(e.toString()));
    } catch (e) {
      eplog(e);
      return Left(HttpFailure(e.toString()));
    }
  } else {
    return Left(InternetFailure());
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
