import 'package:base_app/domain/entities/home_entity.dart';

/// DTO/Model que representa os dados da Home vindos da API/fonte de dados
/// Extende HomeEntity e adiciona funcionalidades de serialização
class HomeModel extends HomeEntity {
  const HomeModel({required super.message, required super.items});

  /// Cria uma instância de HomeModel a partir de uma HomeEntity
  factory HomeModel.fromEntity(HomeEntity entity) {
    return HomeModel(message: entity.message, items: entity.items);
  }

  /// Cria uma instância de HomeModel a partir de um JSON
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      message: json['message'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  /// Converte a instância para JSON
  Map<String, dynamic> toJson() {
    return {'message': message, 'items': items};
  }

  /// Cria uma cópia desta instância com novos valores opcionais
  @override
  HomeModel copyWith({String? message, List<String>? items}) {
    return HomeModel(
      message: message ?? this.message,
      items: items ?? this.items,
    );
  }
}
