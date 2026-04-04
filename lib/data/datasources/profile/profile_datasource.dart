import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:base_app/domain/dto/profile_dto.dart';

class ProfileDatasource {
  ProfileDatasource({required HttpService httpService})
    : _httpService = httpService;
  final HttpService _httpService;

  Future<BaseResponse> getProfile() async {
    final response = await _httpService.get('/users/getProfile');
    return response;
  }

  Future<BaseResponse> updateProfile(ProfileDto data) async {
    final response = await _httpService.put(
      '/users/update',
      data: data.toMap(),
      queryParameters: {'id': data.id},
    );
    return response;
  }
}
