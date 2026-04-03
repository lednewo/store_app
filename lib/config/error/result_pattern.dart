sealed class Result<T> {
  const Result();

  /// Creates an instance of Result containing a value
  factory Result.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory Result.error(Exception error) => Error(error);

  /// Pattern matching helper — elimina switch/cast boilerplate
  ///
  /// Exemplo:
  /// ```dart
  /// result.when(
  ///   ok: (data) => emit(Loaded(data)),
  ///   error: (e) => emit(MyError('$e')),
  /// );
  /// ```
  R when<R>({
    required R Function(T value) ok,
    required R Function(Exception error) error,
  }) {
    return switch (this) {
      Ok<T>(:final value) => ok(value),
      Error<T>(error: final e) => error(e),
    };
  }

  /// Versão assíncrona do [when]
  Future<R> whenAsync<R>({
    required Future<R> Function(T value) ok,
    required Future<R> Function(Exception error) error,
  }) async {
    return switch (this) {
      Ok<T>(:final value) => ok(value),
      Error<T>(error: final e) => error(e),
    };
  }

  /// Retorna o valor se Ok, ou null se Error
  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Error<T>() => null,
  };

  /// Retorna true se o resultado é Ok
  bool get isOk => this is Ok<T>;

  /// Retorna true se o resultado é Error
  bool get isError => this is Error<T>;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error(this.error);

  /// Returned error in result
  final Exception error;
}
