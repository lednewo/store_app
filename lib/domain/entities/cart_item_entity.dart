import 'package:flutter/foundation.dart';

@immutable
class CartItemEntity {
  const CartItemEntity({
    required this.productId,
    required this.productName,
    required this.price,
    required this.cor,
    required this.tamanho,
    required this.quantidade,
  });

  final String productId;
  final String productName;
  final double price;
  final String cor;
  final int tamanho;
  final int quantidade;

  double get subtotal => price * quantidade;

  CartItemEntity copyWith({
    String? productId,
    String? productName,
    double? price,
    String? cor,
    int? tamanho,
    int? quantidade,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      price: price ?? this.price,
      cor: cor ?? this.cor,
      tamanho: tamanho ?? this.tamanho,
      quantidade: quantidade ?? this.quantidade,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemEntity &&
          productId == other.productId &&
          cor == other.cor &&
          tamanho == other.tamanho;

  @override
  int get hashCode => Object.hash(productId, cor, tamanho);
}
