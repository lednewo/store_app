import 'dart:developer';

import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:dio/dio.dart';

/// Implementação do HttpService usando Dio
class DioHttpService implements HttpService {
  const DioHttpService(this._dio);

  final Dio _dio;

  @override
  Future<BaseResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromDioResponse(response);
    } on DioException catch (e) {
      log('❌ GET $path: $e', name: 'HTTP');
      return BaseResponse.fromDioError(e);
    }
  }

  @override
  Future<BaseResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromDioResponse(response);
    } on DioException catch (e) {
      log('❌ POST $path: $e', name: 'HTTP');
      return BaseResponse.fromDioError(e);
    }
  }

  @override
  Future<BaseResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromDioResponse(response);
    } on DioException catch (e) {
      log('❌ PUT $path: $e', name: 'HTTP');
      return BaseResponse.fromDioError(e);
    }
  }

  @override
  Future<BaseResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromDioResponse(response);
    } on DioException catch (e) {
      log('❌ PATCH $path: $e', name: 'HTTP');
      return BaseResponse.fromDioError(e);
    }
  }

  @override
  Future<BaseResponse> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return BaseResponse.fromDioResponse(response);
    } on DioException catch (e) {
      log('❌ DELETE $path: $e', name: 'HTTP');
      return BaseResponse.fromDioError(e);
    }
  }

  @override
  Future<BaseResponse> download(
    String path,
    String savePath, {
    Map<String, dynamic>? headers,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    try {
      log('⬇️  DOWNLOAD $path -> $savePath', name: 'HTTP');
      final response = await _dio.download(
        path,
        savePath,
        options: Options(headers: headers),
        onReceiveProgress: onReceiveProgress,
      );
      log('✅ DOWNLOAD completed: ${response.statusCode}', name: 'HTTP');
      return BaseResponse.fromDioResponse(response);
    } catch (e) {
      log('❌ DOWNLOAD $path: $e', name: 'HTTP');
      if (e is DioException) return BaseResponse.fromDioError(e);
      rethrow;
    }
  }

  // /// Converte Response do Dio para HttpResponse agnóstico
  // HttpResponse _mapResponse(Response<dynamic> response) {
  //   return HttpResponse(
  //     data: response.data,
  //     statusCode: response.statusCode ?? 0,
  //     statusMessage: response.statusMessage,
  //     headers: response.headers.map,
  //   );
  // }
}
