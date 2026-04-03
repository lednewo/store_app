import 'package:base_app/domain/entities/profile_entity.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<void> saveExpirationDate(DateTime expirationDate);
  Future<String?> getToken();
  Future<DateTime?> getExpirationDate();

  Future<bool> isTokenExpired();
  Future<bool> isTokenNearExpiration({Duration threshold});

  Future<ProfileEntity?> getLocalProfile();
  Future<void> saveLocalProfile(ProfileEntity profile);
  Future<void> clearSession();
}
