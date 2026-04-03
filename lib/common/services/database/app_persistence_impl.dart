import 'package:base_app/common/services/database/app_persistence.dart';
import 'package:base_app/common/services/database/app_persistence_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPersistenceImpl implements AppPersistence {
  @override
  Future<String?> buscarDadoUnico({required AppPersistenceKeys key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.value);
  }

  @override
  Future<List<String>> buscarDados({required AppPersistenceKeys key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key.value) ?? [];
  }

  @override
  Future<void> limparDados({required AppPersistenceKeys key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key.value);
  }

  @override
  Future<void> removerDadoUnico({required AppPersistenceKeys key}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key.value);
  }

  @override
  Future<void> salvarDadoUnico({
    required AppPersistenceKeys key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key.value, value);
  }

  @override
  Future<void> salvarDados({
    required AppPersistenceKeys key,
    required List<String> values,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key.value, values);
  }

  @override
  Future<void> deletarDados({required List<AppPersistenceKeys> keys}) async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in keys) {
      await prefs.remove(key.value);
    }
  }
}
