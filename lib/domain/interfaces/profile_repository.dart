import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/domain/dto/profile_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity?>> getProfile();
  Future<Result<DefaultReturnEntity>> updateProfile(ProfileDto dto);
}
