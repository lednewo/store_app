import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/home_remote_datasource.dart';
import 'package:base_app/data/models/home_model.dart';
import 'package:base_app/domain/entities/home_entity.dart';
import 'package:base_app/domain/interfaces/home_repository.dart';

/// Implementação concreta do HomeRepository
/// Utiliza HomeRemoteDataSource para buscar dados e trata erros
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<Result<HomeEntity>> loadHomeData() async {
    try {
      final responseData = await _remoteDataSource.getMockHomeData();
      return Result.ok(HomeModel.fromJson(responseData));
    } on Exception catch (e) {
      return Result.error(
        Exception('Failed to load home data: $e'),
      );
    }
  }

  @override
  Future<Result<HomeEntity>> refreshHomeData() async {
    try {
      final responseData = await _remoteDataSource.getMockHomeData();
      return Result.ok(HomeModel.fromJson(responseData));
    } on Exception catch (e) {
      return Result.error(
        Exception('Failed to refresh home data: $e'),
      );
    }
  }
}
