import 'package:base_app/domain/entities/cart_item_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartUpdated extends CartState {
  const CartUpdated(this.items);

  final List<CartItemEntity> items;

  double get total => items.fold(0, (sum, i) => sum + i.subtotal);
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantidade);
  bool get isEmpty => items.isEmpty;
}

class CartOrdering extends CartState {
  const CartOrdering(this.items);

  final List<CartItemEntity> items;
}

class CartOrderSuccess extends CartState {
  const CartOrderSuccess({required this.message, required this.items});

  final String message;
  final List<CartItemEntity> items;
}

class CartOrderError extends CartState {
  const CartOrderError({required this.message, required this.items});

  final String message;
  final List<CartItemEntity> items;
}
