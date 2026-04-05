import 'package:base_app/domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.productId,
    required super.productName,
    required super.price,
    required super.cor,
    required super.tamanho,
    required super.quantidade,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    productId: json['productId'] as String? ?? '',
    productName: json['productName'] as String? ?? '',
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
    cor: json['cor'] as String? ?? '',
    tamanho: json['tamanho'] as int? ?? 0,
    quantidade: json['quantidade'] as int? ?? 0,
  );

  factory CartItemModel.fromEntity(CartItemEntity entity) => CartItemModel(
    productId: entity.productId,
    productName: entity.productName,
    price: entity.price,
    cor: entity.cor,
    tamanho: entity.tamanho,
    quantidade: entity.quantidade,
  );

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'cor': cor,
    'tamanho': tamanho,
    'quantidade': quantidade,
  };
}
