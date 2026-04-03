import 'dart:developer';

import 'package:base_app/common/utils/base_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppLoggerService {
  static void logInfo(String message, {String tag = 'App'}) {
    log('ℹ️ $message', name: tag);
  }

  static void logDebug(String message, {String tag = 'Debug'}) {
    if (kDebugMode) {
      log('🐞 $message', name: tag);
    }
  }

  static Future<void> logError(
    String message, {
    required Object error,
    StackTrace? stackTrace,
    String tag = 'Error',
  }) async {
    log('❌ $message', name: tag, error: error, stackTrace: stackTrace);

    // await AppCrash.enviarMonitoramento(error: error, stackTrace: stackTrace);
  }

  static void logRequest(String method, Uri uri, {dynamic body}) {
    log('📤 [$method] => $uri', name: 'HttpService');
    if (body != null) log('🧾 Body: $body', name: 'HttpService');
  }

  static void logResponse(Uri uri, int? statusCode, dynamic data) {
    log('📥 [${statusCode ?? '??'}] <= $uri', name: 'HttpService');
    log('📦 Response: $data', name: 'HttpService');
  }

  static Future<void> logDioError(
    DioException error,
    ResponseStatus status,
  ) async {
    log('❌ [BaseResponse] DIO ERROR', name: 'HttpService');
    log('➡️ URL: ${error.requestOptions.uri}', name: 'HttpService');
    log('💥 STATUS: $status', name: 'HttpService');
    log('📨 RESPONSE: ${error.response?.data}', name: 'HttpService');
    log('🧵 ERROR: ${error.message}', name: 'HttpService');

    // await AppCrash.enviarMonitoramento(error: error);
  }
}
