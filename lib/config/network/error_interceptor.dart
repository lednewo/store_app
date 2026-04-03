import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

/// Interceptor centralizado para tratamento de erros HTTP.
///
/// Converte erros de rede em [DioException] com mensagens claras,
/// facilitando o tratamento nos repositories.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final DioException mappedError;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        mappedError = DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'Connection timed out',
        );
      case DioExceptionType.connectionError:
        mappedError = DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'No internet connection',
        );
      case DioExceptionType.badResponse:
        mappedError = _handleBadResponse(err);
      case DioExceptionType.cancel:
        mappedError = err;
      case DioExceptionType.badCertificate:
        mappedError = DioException(
          requestOptions: err.requestOptions,
          type: err.type,
          message: 'Certificate verification failed',
        );
      case DioExceptionType.unknown:
        if (err.error is SocketException) {
          mappedError = DioException(
            requestOptions: err.requestOptions,
            type: DioExceptionType.connectionError,
            message: 'No internet connection',
          );
        } else {
          mappedError = err;
        }
    }

    log(
      '${mappedError.requestOptions.method} '
      '${mappedError.requestOptions.path} → '
      '${mappedError.message}',
      name: 'ErrorInterceptor',
    );

    handler.next(mappedError);
  }

  DioException _handleBadResponse(DioException err) {
    final statusCode = err.response?.statusCode ?? 0;
    final String message;

    switch (statusCode) {
      case 400:
        message = 'Bad request';
      case 401:
        message = 'Unauthorized';
      case 403:
        message = 'Forbidden';
      case 404:
        message = 'Resource not found';
      case 422:
        message = 'Validation error';
      case 429:
        message = 'Too many requests';
      case >= 500:
        message = 'Server error ($statusCode)';
      default:
        message = 'HTTP error $statusCode';
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      message: message,
    );
  }
}
