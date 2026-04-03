import 'package:base_app/common/services/database/app_persistence_keys.dart';

abstract class AppPersistence {
  Future<void> salvarDadoUnico({
    required AppPersistenceKeys key,
    required String value,
  });

  Future<void> salvarDados({
    required AppPersistenceKeys key,
    required List<String> values,
  });

  Future<void> removerDadoUnico({required AppPersistenceKeys key});
  Future<void> deletarDados({required List<AppPersistenceKeys> keys});
  Future<String?> buscarDadoUnico({required AppPersistenceKeys key});
  Future<List<String>> buscarDados({required AppPersistenceKeys key});
  Future<void> limparDados({required AppPersistenceKeys key});
}
