import 'dart:convert';

import 'package:base_app/common/services/storage_service.dart';
import 'package:base_app/data/models/cart_item_model.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/dto/order_item_dto.dart';
import 'package:base_app/domain/entities/cart_item_entity.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const _kCartStorageKey = 'cart_items';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._orderRepository, this._storageService)
    : super(const CartInitial()) {
    _loadCart();
  }

  final OrderRepository _orderRepository;
  final StorageService _storageService;

  List<CartItemEntity> get _currentItems => switch (state) {
    CartUpdated(:final items) => List<CartItemEntity>.from(items),
    CartOrdering(:final items) => List<CartItemEntity>.from(items),
    CartOrderError(:final items) => List<CartItemEntity>.from(items),
    _ => <CartItemEntity>[],
  };

  Future<void> _loadCart() async {
    final jsonList = await _storageService.getStringList(_kCartStorageKey);
    if (jsonList == null || jsonList.isEmpty) return;
    final items = jsonList
        .map(
          (e) => CartItemModel.fromJson(
            jsonDecode(e) as Map<String, dynamic>,
          ),
        )
        .toList();
    emit(CartUpdated(List.unmodifiable(items)));
  }

  Future<void> _saveCart(List<CartItemEntity> items) async {
    final jsonList = items
        .map((e) => jsonEncode(CartItemModel.fromEntity(e).toJson()))
        .toList();
    await _storageService.setStringList(_kCartStorageKey, jsonList);
  }

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

    final updatedItems = List<CartItemEntity>.unmodifiable(items);
    emit(CartUpdated(updatedItems));
    _saveCart(updatedItems);
  }

  void removeItem(String productId, String cor, int tamanho) {
    final items = _currentItems
      ..removeWhere(
        (i) => i.productId == productId && i.cor == cor && i.tamanho == tamanho,
      );
    final updatedItems = List<CartItemEntity>.unmodifiable(items);
    emit(CartUpdated(updatedItems));
    _saveCart(updatedItems);
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
      final updatedItems = List<CartItemEntity>.unmodifiable(items);
      emit(CartUpdated(updatedItems));
      _saveCart(updatedItems);
    }
  }

  void clearCart() {
    emit(const CartUpdated([]));
    _storageService.remove(_kCartStorageKey);
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
