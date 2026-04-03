import 'package:base_app/domain/entities/product_entity.dart';

class PaginatedProductsEntity {
  PaginatedProductsEntity({
    required this.page,
    required this.size,
    required this.totalPages,
    required this.data,
  });

  final int page;
  final int size;
  final int totalPages;
  final List<ProductEntity> data;
}
