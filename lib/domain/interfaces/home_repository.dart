import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/domain/entities/home_entity.dart';

/// Contrato que define os métodos de acesso aos dados da Home
/// Usado pela camada de presentation (Cubit) para obter dados da home
abstract class HomeRepository {
  /// Carrega os dados iniciais da tela Home
  ///
  /// Returns [Result<HomeEntity>] contendo os dados da home ou um erro
  Future<Result<HomeEntity>> loadHomeData();

  /// Atualiza/recarrega os dados da home
  ///
  /// Returns [Result<HomeEntity>] contendo os dados atualizados ou um erro
  Future<Result<HomeEntity>> refreshHomeData();
}
