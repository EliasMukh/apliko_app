abstract class ServiceException implements Exception {}

class ServerException implements ServiceException {}

class HttpException implements ServiceException {
  final String message;

  HttpException(this.message);
}