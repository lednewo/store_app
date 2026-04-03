enum AppPersistenceKeys {
  token('token'),
  tokenExpirationDate('tokenExpirationDate'),
  userId('userId'),
  userProfile('userProfile');

  const AppPersistenceKeys(this.value);
  final String value;
}
