import 'dart:developer';

import 'package:base_app/common/services/database/app_persistence.dart';
import 'package:base_app/common/services/database/app_persistence_keys.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._persistence);

  final AppPersistence _persistence;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _persistence.buscarDadoUnico(
      key: AppPersistenceKeys.token,
    );
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      log(
        'Unauthorized — token may be expired',
        name: 'AuthInterceptor',
      );
    }
    super.onError(err, handler);
  }
}
