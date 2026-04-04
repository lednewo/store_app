import 'package:base_app/domain/entities/order_detail_entity.dart';
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

class OrderStatusUpdated extends OrdersState {
  const OrderStatusUpdated(this.message);
  final String message;
}

class OrderStatusUpdateError extends OrdersState {
  const OrderStatusUpdateError(this.message);
  final String message;
}

class OrderDetailsLoaded extends OrdersState {
  const OrderDetailsLoaded(this.orderDetails);
  final OrderDetailEntity orderDetails;
}

class OrderDeleted extends OrdersState {
  const OrderDeleted(this.message);
  final String message;
}

class OrderDeleteError extends OrdersState {
  const OrderDeleteError(this.message);
  final String message;
}
