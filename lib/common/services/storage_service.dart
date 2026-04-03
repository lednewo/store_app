/// Interface abstrata para serviços de armazenamento local.
///
/// Define os contratos para operações básicas de armazenamento,
/// permitindo diferentes implementações (SharedPreferences, Hive, etc.).
abstract class StorageService {
  /// Armazena uma string no armazenamento local.
  Future<void> setString(String key, String value);

  /// Recupera uma string do armazenamento local.
  /// Retorna null se a chave não existir.
  Future<String?> getString(String key);

  /// Armazena um valor booleano no armazenamento local.
  Future<void> setBool(String key, {required bool value});

  /// Recupera um valor booleano do armazenamen to local.
  /// Retorna null se a chave não existir.
  Future<bool?> getBool(String key);

  /// Armazena um número inteiro no armazenamento local.
  Future<void> setInt(String key, int value);

  /// Recupera um número inteiro do armazenamento local.
  /// Retorna null se a chave não existir.
  Future<int?> getInt(String key);

  /// Armazena um número decimal no armazenamento local.
  Future<void> setDouble(String key, double value);

  /// Recupera um número decimal do armazenamento local.
  /// Retorna null se a chave não existir.
  Future<double?> getDouble(String key);

  /// Armazena uma lista de strings no armazenamento local.
  Future<void> setStringList(String key, List<String> value);

  /// Recupera uma lista de strings do armazenamento local.
  /// Retorna null se a chave não existir.
  Future<List<String>?> getStringList(String key);

  /// Remove uma chave específica do armazenamento local.
  Future<void> remove(String key);

  /// Limpa todo o armazenamento local.
  Future<void> clear();

  /// Verifica se uma chave existe no armazenamento local.
  Future<bool> containsKey(String key);

  /// Retorna todas as chaves existentes no armazenamento local.
  Future<Set<String>> getKeys();
}
