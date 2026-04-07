import 'dart:developer';

import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/config/error/failure.dart';
import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/auth/auth_local_datasource.dart';
import 'package:base_app/data/datasources/profile/profile_datasource.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/data/models/profile_model.dart';
import 'package:base_app/domain/dto/profile_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:base_app/domain/interfaces/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required ProfileDatasource profileDatasource,
    required AuthLocalDatasource authLocalDatasource,
  }) : _profileDatasource = profileDatasource,
       _authLocalDatasource = authLocalDatasource;

  final ProfileDatasource _profileDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  @override
  Future<Result<ProfileEntity?>> getProfile() async {
    try {
      final result = await _profileDatasource.getProfile();
      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter perfil',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final profile = ProfileModel.fromMap(result.data as Map<String, dynamic>);
      await _authLocalDatasource.saveLocalProfile(profile);
      _saveLoginAndUserType(loginType: profile.userType.loginType);
      return Result.ok(profile);
    } on Exception catch (e) {
      log('Error in getProfile: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to get profile: $e'),
      );
    }
  }

  void _saveLoginAndUserType({
    LoginType? loginType,
  }) {
    if (loginType != null) {
      LoginDetect.setLoginType(loginType);
    }
  }

  @override
  Future<Result<DefaultReturnEntity>> updateProfile(ProfileDto dto) async {
    try {
      final result = await _profileDatasource.updateProfile(dto);
      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao atualizar perfil',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final defaultReturn = DefaultReturnModel.fromMap(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(defaultReturn);
    } on Exception catch (e) {
      log('Error in getLocalProfile: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to update profile: $e'),
      );
    }
  }
}
