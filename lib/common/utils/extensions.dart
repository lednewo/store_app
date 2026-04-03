import 'package:flutter/foundation.dart';

extension StringExtensions on String {
  /// Capitaliza a primeira letra da string
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Remove espaços em branco no início e fim
  String trimAll() => trim();

  /// Verifica se a string é um email válido
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(this);
  }

  /// Verifica se a string é um número
  bool get isNumeric {
    return double.tryParse(this) != null;
  }
}

extension IterableExtensions<T> on Iterable<T> {
  /// Mapeia e filtra nulos
  Iterable<R> mapNotNull<R>(R? Function(T) transform) {
    return map(transform).where((item) => item != null).cast<R>();
  }
}

@immutable
class AppConstants {
  static const String appName = 'Base App';
  static const String appVersion = '1.0.0';

  // Timeouts
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Sizes
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const double largePadding = 24;

  // Border radius
  static const double defaultBorderRadius = 8;
  static const double smallBorderRadius = 4;
  static const double largeBorderRadius = 16;
}
