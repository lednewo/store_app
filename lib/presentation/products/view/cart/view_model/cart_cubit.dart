import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/dto/order_item_dto.dart';
import 'package:base_app/domain/entities/cart_item_entity.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._orderRepository) : super(const CartInitial());

  final OrderRepository _orderRepository;

  List<CartItemEntity> get _currentItems => switch (state) {
    CartUpdated(:final items) => List<CartItemEntity>.from(items),
    CartOrdering(:final items) => List<CartItemEntity>.from(items),
    CartOrderError(:final items) => List<CartItemEntity>.from(items),
    _ => <CartItemEntity>[],
  };

  void addItem(CartItemEntity item) {
    final items = _currentItems;
    final existingIndex = items.indexWhere(
      (i) =>
          i.productId == item.productId &&
          i.cor == item.cor &&
          i.tamanho == item.tamanho,
    );

    if (existingIndex != -1) {
      items[existingIndex] = items[existingIndex].copyWith(
        quantidade: items[existingIndex].quantidade + item.quantidade,
      );
    } else {
      items.add(item);
    }

    emit(CartUpdated(List.unmodifiable(items)));
  }

  void removeItem(String productId, String cor, int tamanho) {
    final items = _currentItems
      ..removeWhere(
        (i) => i.productId == productId && i.cor == cor && i.tamanho == tamanho,
      );
    emit(CartUpdated(List.unmodifiable(items)));
  }

  void updateQuantity(
    String productId,
    String cor,
    int tamanho,
    int quantidade,
  ) {
    if (quantidade <= 0) {
      removeItem(productId, cor, tamanho);
      return;
    }
    final items = _currentItems;
    final index = items.indexWhere(
      (i) => i.productId == productId && i.cor == cor && i.tamanho == tamanho,
    );
    if (index != -1) {
      items[index] = items[index].copyWith(quantidade: quantidade);
      emit(CartUpdated(List.unmodifiable(items)));
    }
  }

  void clearCart() {
    emit(const CartUpdated([]));
  }

  Future<void> checkout() async {
    final items = _currentItems;
    if (items.isEmpty) return;

    emit(CartOrdering(List.unmodifiable(items)));

    final dto = OrderDto(
      items: items
          .map(
            (i) => OrderItemDto(
              productId: i.productId,
              quantidade: i.quantidade,
              cor: i.cor,
              tamanho: i.tamanho,
            ),
          )
          .toList(),
    );

    final result = await _orderRepository.createOrder(dto);

    result.when(
      ok: (data) {
        emit(CartOrderSuccess(message: data.message, items: items));
      },
      error: (e) {
        emit(
          CartOrderError(
            message: e.toString(),
            items: List.unmodifiable(items),
          ),
        );
      },
    );
  }
}
