import 'package:flutter/foundation.dart';

/// Entidade que representa os dados da tela Home.
/// Contém informações imutáveis sobre a mensagem de
/// boas-vindas e lista de itens.
@immutable
class HomeEntity {
  const HomeEntity({required this.message, required this.items});

  /// Mensagem de boas-vindas da home
  final String message;

  /// Lista de itens disponíveis na home
  final List<String> items;

  /// Cria uma cópia desta entidade com novos valores opcionais
  HomeEntity copyWith({String? message, List<String>? items}) {
    return HomeEntity(
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeEntity &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          listEquals(items, other.items);

  @override
  int get hashCode => message.hashCode ^ items.hashCode;

  @override
  String toString() => 'HomeEntity(message: $message, items: $items)';
}
