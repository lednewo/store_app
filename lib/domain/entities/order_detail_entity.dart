import 'package:base_app/domain/entities/order_item_entity.dart';
import 'package:base_app/domain/entities/profile_entity.dart';

class OrderDetailEntity {
  OrderDetailEntity({
    required this.orderId,
    required this.total,
    required this.orderDate,
    required this.status,
    required this.comprador,
    required this.items,
  });
  final String orderId;
  final double total;
  final DateTime orderDate;
  final String status;
  final ProfileEntity comprador;
  final List<OrderItemEntity> items;
}
