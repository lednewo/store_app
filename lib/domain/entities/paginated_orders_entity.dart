import 'package:base_app/domain/entities/order_entity.dart';

class PaginatedOrdersEntity {
  PaginatedOrdersEntity({
    required this.page,
    required this.size,
    required this.totalPages,
    required this.data,
  });

  final int page;
  final int size;
  final int totalPages;
  final List<OrderEntity> data;
}
