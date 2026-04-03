import 'package:base_app/common/utils/app_logger_detect_service.dart';
import 'package:dio/dio.dart';

enum ResponseStatus {
  success,
  error,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  noConnection,
  mappingError,
  unknown,
}

class BaseResponse {
  BaseResponse({
    required this.status,
    this.data,
    this.message,
    this.statusCode,
  });
  factory BaseResponse.fromDioResponse(Response response) {
    AppLoggerService.logResponse(
      response.realUri,
      response.statusCode,
      response.data,
    );
    return BaseResponse(
      status: ResponseStatus.success,
      data: response.data,
      message: response.statusMessage,
      statusCode: response.statusCode,
    );
  }
  factory BaseResponse.fromDioError(DioException error) {
    final code = error.response?.statusCode;

    final status = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ResponseStatus.timeout,
      DioExceptionType.badResponse => switch (code) {
        401 => ResponseStatus.unauthorized,
        403 => ResponseStatus.forbidden,
        404 => ResponseStatus.notFound,
        _ => ResponseStatus.error,
      },
      DioExceptionType.connectionError => ResponseStatus.noConnection,
      DioExceptionType.cancel => ResponseStatus.unknown,
      DioExceptionType.unknown => ResponseStatus.unknown,
      DioExceptionType.badCertificate => ResponseStatus.unknown,
    };

    AppLoggerService.logDioError(error, status);
    return BaseResponse(
      status: status,
      message: _extractMessage(error),
      statusCode: code,
    );
  }
  final dynamic data; // agora pode ser Map, List, String, etc
  final String? message;
  final int? statusCode;
  final ResponseStatus status;

  static String _extractMessage(DioException e) {
    if (e.response?.data is Map && e.response?.data['message'] != null) {
      return e.response!.data['message'] as String;
    }
    return e.message ?? 'Erro de rede';
  }

  bool get isSuccess => status == ResponseStatus.success;
}
