import 'package:base_app/data/models/product_model.dart';
import 'package:base_app/domain/entities/latest_products_entity.dart';

class LatestProductsModel extends LatestProductsEntity {
  LatestProductsModel({required super.products});

  factory LatestProductsModel.fromJson(Map<String, dynamic> json) {
    return LatestProductsModel(
      products: (json['products'] as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
