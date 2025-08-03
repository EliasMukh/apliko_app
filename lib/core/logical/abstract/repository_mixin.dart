import 'package:aplico/core/utils/funcs.dart';
import 'package:aplico/core/utils/internet_info.dart';
import 'package:aplico/features/authentication/data/data%20sources/auth_remote_ds.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../errors/error_model.dart';
import '../errors/failures.dart';

Future<Either<Failure, T>> sendRequest<T>(
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
