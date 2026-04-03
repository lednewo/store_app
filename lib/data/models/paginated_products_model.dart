import 'package:base_app/data/models/product_model.dart';
import 'package:base_app/domain/entities/paginated_products_entity.dart';

class PaginatedProductsModel extends PaginatedProductsEntity {
  PaginatedProductsModel({
    required super.page,
    required super.size,
    required super.totalPages,
    required super.data,
  });

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) {
    return PaginatedProductsModel(
      page: json['page'] as int,
      size: json['size'] as int,
      totalPages: json['totalPages'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
