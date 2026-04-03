import 'dart:developer';

import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/config/error/failure.dart';
import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/auth/auth_datasource.dart';
import 'package:base_app/data/datasources/auth/auth_local_datasource.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/data/models/login_model.dart';
import 'package:base_app/data/models/profile_model.dart';
import 'package:base_app/domain/dto/login_dto.dart';
import 'package:base_app/domain/dto/register_dto.dart';
import 'package:base_app/domain/entities/login_entity.dart';
import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:base_app/domain/interfaces/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl({
    required AuthDatasource authDatasource,
    required AuthLocalDatasource authLocalDatasource,
  }) : _authDatasource = authDatasource,
       _authLocalDatasource = authLocalDatasource;

  final AuthDatasource _authDatasource;
  final AuthLocalDatasource _authLocalDatasource;
  bool? _isAuthenticated;

  @override
  Future<Result<ProfileEntity?>> getLocalProfile() async {
    try {
      final localProfile = await _authLocalDatasource.getLocalProfile();
      if (localProfile == null) {
        return Result.ok(null);
      }

      _saveLoginAndUserType(loginType: localProfile.userType.loginType);

      return Result.ok(localProfile);
    } on Exception catch (e) {
      log('Error in getLocalProfile: $e');
      return Result.error(Exception('Failed to get local profile: $e'));
    }
  }

  @override
  Future<Result<ProfileEntity?>> getProfile() async {
    try {
      final result = await _authDatasource.getProfile();
      if (result.statusCode != 200) {
        return Result.error(
          Exception(
            'Failed to get profile: ${result.statusCode} ${result.data}',
          ),
        );
      }

      final profile = ProfileModel.fromMap(result.data as Map<String, dynamic>);
      await _authLocalDatasource.saveLocalProfile(profile);
      _saveLoginAndUserType(loginType: profile.userType.loginType);
      return Result.ok(profile);
    } on Exception catch (e) {
      log('Error in getProfile: $e');
      return Result.error(Exception('Failed to get profile: $e'));
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }

    final token = await _authLocalDatasource.getToken();
    final isExpired = await _authLocalDatasource.isTokenExpired();
    final isAuthenticated = token != null && token.isNotEmpty && !isExpired;

    _isAuthenticated = isAuthenticated;
    return isAuthenticated;
  }

  @override
  Future<Result<LoginEntity>> login(LoginDto dto) async {
    try {
      final result = await _authDatasource.login(dto);

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao realizar login',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final responseData = LoginModel.fromMap(
        result.data as Map<String, dynamic>,
      );

      final saveResult = await _saveUserSessionDaata(responseData);
      if (saveResult.isError) {
        return Result.error(
          Exception('Failed to save user session data: ${saveResult.isError}'),
        );
      }
      _isAuthenticated = true;

      return Result.ok(responseData);
    } on Exception catch (e) {
      return Result.error(
        Failure(
          errorMessage: 'Failed to login: $e',
        ),
      );
    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    await _authLocalDatasource.clearSession();
    log('User logged out, local session cleared');
    _isAuthenticated = false;
    LoginDetect.setLoginType(LoginType.cliente);
    notifyListeners();
    return Result.ok(null);
  }

  @override
  Future<Result<DefaultReturnModel>> register(RegisterDto dto) async {
    try {
      final result = await _authDatasource.register(dto);
      final responseData = DefaultReturnModel.fromMap(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(responseData);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to register: $e'));
    }
  }

  @override
  Future<void> saveLocalProfile(LoginEntity loginEntity) async {
    await _authLocalDatasource.saveLocalProfile(loginEntity.profile);
  }

  Future<Result<void>> _saveUserSessionDaata(LoginModel login) async {
    try {
      _saveLoginAndUserType(loginType: login.role.loginType);
      await _authLocalDatasource.saveToken(login.token);
      await _authLocalDatasource.saveExpirationDate(
        DateTime.parse(login.expirationDate),
      );
      await _authLocalDatasource.saveLocalProfile(login.profile);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(Exception('Failed to save user session data: $e'));
    }
  }

  void _saveLoginAndUserType({
    LoginType? loginType,
  }) {
    if (loginType != null) {
      LoginDetect.setLoginType(loginType);
    }
  }
}
