import 'package:base_app/domain/entities/order_item_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';

class OrderEntity {
  OrderEntity({
    required this.orderId,
    required this.total,
    required this.orderDate,
    required this.status,
    required this.items,
  });
  final String orderId;
  final double total;
  final DateTime orderDate;
  final OrderStatusEnum status;
  final List<OrderItemEntity> items;
}
