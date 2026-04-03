import 'package:base_app/domain/entities/paginated_products_entity.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsSuccess extends ProductsState {
  const ProductsSuccess(this.products);
  final PaginatedProductsEntity products;
}

class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;
}

class ProductDetailsSuccess extends ProductsState {
  const ProductDetailsSuccess(this.product);
  final ProductEntity product;
}

class ProductDeleteSuccess extends ProductsState {
  const ProductDeleteSuccess(this.message);
  final String message;
}

class ProductDeleteError extends ProductsState {
  const ProductDeleteError(this.message);
  final String message;
}

class ProductUpdateSuccess extends ProductsState {
  const ProductUpdateSuccess(this.message);
  final String message;
}
