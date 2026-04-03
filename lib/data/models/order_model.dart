import 'package:base_app/data/models/order_item_model.dart';
import 'package:base_app/domain/entities/order_entity.dart';
import 'package:base_app/domain/enum/order_status_enum.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    required super.orderId,
    required super.total,
    required super.orderDate,
    required super.status,
    required super.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'] as String,
      total: json['total'] as double,
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: OrderStatusEnum.fromString(json['status'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
