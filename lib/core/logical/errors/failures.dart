import 'error_model.dart';

class Failure {}

class ServerFailure extends Failure {}

class InternetFailure extends Failure {}

class HttpFailure extends Failure {
  final String message;
  final Map<String, dynamic>? data;
  final ErrorModel? errorModel;
  final Map<String, String>? errors; // إضافة errors هنا

  HttpFailure(
    this.message, {
    this.errorModel,
    this.data,
    this.errors, // تمرير الأخطاء هنا
  });
}
