import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:base_app/domain/dto/login_dto.dart';
import 'package:base_app/domain/dto/register_dto.dart';

class AuthDatasource {
  AuthDatasource({required HttpService httpService})
    : _httpService = httpService;
  final HttpService _httpService;

  Future<BaseResponse> login(LoginDto dto) async {
    final response = await _httpService.post(
      '/auth/login',
      data: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> register(RegisterDto dto) async {
    final response = await _httpService.post(
      '/auth/signup',
      data: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> logout() async {
    final response = await _httpService.post('/auth/logout');
    return response;
  }

  Future<BaseResponse> refreshToken() async {
    final response = await _httpService.post('/auth/refresh-token');
    return response;
  }
}
