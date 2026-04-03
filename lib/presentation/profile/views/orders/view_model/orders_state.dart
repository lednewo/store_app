import 'package:base_app/domain/entities/paginated_orders_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.orders);

  final PaginatedOrdersEntity orders;
}

class OrdersError extends OrdersState {
  const OrdersError(this.message);

  final String message;
}
