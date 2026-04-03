import 'package:base_app/data/repositories/order_model.dart';
import 'package:base_app/domain/entities/paginated_orders_entity.dart';

class PaginatedOrdersModel extends PaginatedOrdersEntity {
  PaginatedOrdersModel({
    required super.page,
    required super.size,
    required super.totalPages,
    required super.data,
  });

  factory PaginatedOrdersModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOrdersModel(
      page: json['page'] as int,
      size: json['size'] as int,
      totalPages: json['totalPages'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
