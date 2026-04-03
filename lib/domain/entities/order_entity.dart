import 'package:base_app/domain/entities/order_item_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';

class OrderEntity {
  OrderEntity({
    required this.id,
    required this.total,
    required this.orderDate,
    required this.status,
    required this.items,
  });
  final String id;
  final int total;
  final DateTime orderDate;
  final OrderStatusEnum status;
  final List<OrderItemEntity> items;
}
