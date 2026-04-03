import 'dart:convert';

import 'package:base_app/common/services/database/app_persistence.dart';
import 'package:base_app/common/services/database/app_persistence_keys.dart';
import 'package:base_app/data/datasources/auth/auth_local_datasource.dart';
import 'package:base_app/data/models/profile_model.dart';
import 'package:base_app/domain/entities/profile_entity.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  const AuthLocalDatasourceImpl(this._appPersistence);

  final AppPersistence _appPersistence;

  static const AppPersistenceKeys _tokenKey = AppPersistenceKeys.token;
  static const AppPersistenceKeys _expirationDateKey =
      AppPersistenceKeys.tokenExpirationDate;
  static const AppPersistenceKeys _profileKey = AppPersistenceKeys.userProfile;

  @override
  Future<void> clearSession() async {
    await _appPersistence.deletarDados(
      keys: [_tokenKey, _expirationDateKey, _profileKey],
    );
  }

  @override
  Future<DateTime?> getExpirationDate() async {
    final str = await _appPersistence.buscarDadoUnico(key: _expirationDateKey);
    if (str == null) return null;
    return DateTime.tryParse(str);
  }

  @override
  Future<ProfileEntity?> getLocalProfile() async {
    final profileJson = await _appPersistence.buscarDadoUnico(key: _profileKey);
    if (profileJson == null || profileJson.isEmpty) return null;

    final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;

    return ProfileModel.fromMap(profileMap);
  }

  @override
  Future<String?> getToken() {
    return _appPersistence.buscarDadoUnico(key: _tokenKey);
  }

  @override
  Future<bool> isTokenExpired() async {
    final expiration = await getExpirationDate();
    if (expiration == null) return true;
    return DateTime.now().isAfter(expiration);
  }

  @override
  Future<bool> isTokenNearExpiration({Duration? threshold}) async {
    final expiration = await getExpirationDate();
    if (expiration == null) return true;

    final refreshThreshold = threshold ?? const Duration(days: 7);
    final nrefreshTime = expiration.subtract(refreshThreshold);
    return DateTime.now().isAfter(nrefreshTime);
  }

  @override
  Future<void> saveExpirationDate(DateTime expirationDate) async {
    await _appPersistence.salvarDadoUnico(
      key: _expirationDateKey,
      value: expirationDate.toIso8601String(),
    );
  }

  @override
  Future<void> saveLocalProfile(ProfileEntity profile) async {
    final profileJson = jsonEncode(ProfileModel.fromEntity(profile).toMap());
    await _appPersistence.salvarDadoUnico(
      key: _profileKey,
      value: profileJson,
    );
  }

  @override
  Future<void> saveToken(String token) async {
    await _appPersistence.salvarDadoUnico(key: _tokenKey, value: token);
  }
}
