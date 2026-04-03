import 'package:base_app/common/services/database/app_persistence.dart';
import 'package:base_app/config/network/auth_interceptor.dart';
import 'package:base_app/config/network/error_interceptor.dart';
import 'package:dio/dio.dart';

Dio makeDio({
  required AppPersistence appPersistence,
  String baseUrl = 'http://10.0.2.2:8080/api',
  bool enableLogs = false,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  if (enableLogs) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  dio.interceptors.add(AuthInterceptor(appPersistence));
  dio.interceptors.add(ErrorInterceptor());
  return dio;
}
