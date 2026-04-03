import 'package:base_app/domain/entities/order_item_entity.dart';

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantidade,
    required super.precoUnitario,
    required super.subtotal,
    required super.cor,
    required super.tamanho,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      quantidade: json['quantidade'] as int,
      precoUnitario: json['precoUnitario'] as double,
      subtotal: json['subtotal'] as double,
      cor: json['cor'] as String,
      tamanho: json['tamanho'] as int,
    );
  }
}
