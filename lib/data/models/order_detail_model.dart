import 'package:base_app/data/models/order_item_model.dart';
import 'package:base_app/data/models/profile_model.dart';
import 'package:base_app/domain/entities/order_detail_entity.dart';

class OrderDetailModel extends OrderDetailEntity {
  OrderDetailModel({
    required super.orderId,
    required super.total,
    required super.orderDate,
    required super.status,
    required super.comprador,
    required super.items,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderId: json['orderId'] as String,
      total: (json['total'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      status: json['status'] as String,
      comprador: ProfileModel.fromMap(
        json['comprador'] as Map<String, dynamic>,
      ),
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
