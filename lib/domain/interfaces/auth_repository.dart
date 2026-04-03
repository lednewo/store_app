import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/domain/dto/login_dto.dart';
import 'package:base_app/domain/dto/register_dto.dart';
import 'package:base_app/domain/entities/login_entity.dart';
import 'package:base_app/domain/entities/profile_entity.dart';
import 'package:flutter/foundation.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;
  Future<Result<LoginEntity>> login(LoginDto dto);
  Future<Result<DefaultReturnModel>> register(RegisterDto dto);
  Future<void> saveLocalProfile(LoginEntity loginEntity);
  Future<Result<ProfileEntity?>> getLocalProfile();
  Future<Result<void>> logout();
  Future<Result<ProfileEntity?>> getProfile();
}
