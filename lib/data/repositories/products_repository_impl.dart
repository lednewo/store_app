import 'dart:developer';

import 'package:base_app/config/error/failure.dart';
import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/products/products_datasource.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/data/models/paginated_products_model.dart';
import 'package:base_app/data/models/product_model.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/paginated_products_entity.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl({required ProductsDatasource productsDatasource})
    : _productsDatasource = productsDatasource;

  final ProductsDatasource _productsDatasource;

  @override
  Future<Result<DefaultReturnEntity>> createProduct(ProductDto dto) async {
    try {
      final result = await _productsDatasource.createProduct(dto);

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao criar produto',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      return Result.ok(
        DefaultReturnModel.fromMap(result.data as Map<String, dynamic>),
      );
    } on Exception catch (e) {
      log('Error in createProduct: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to create product: $e'),
      );
    }
  }

  @override
  Future<Result<PaginatedProductsEntity>> getProducts(PaginationDto dto) async {
    try {
      final result = await _productsDatasource.getProducts(dto);

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter produtos',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final products = PaginatedProductsModel.fromJson(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(products);
    } on Exception catch (e) {
      log('Error in getProducts: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to get products: $e'),
      );
    }
  }

  @override
  Future<Result<ProductEntity>> getById(String id) async {
    try {
      final result = await _productsDatasource.getById(id);

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter produto por id',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final product = ProductModel.fromJson(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(product);
    } on Exception catch (e) {
      log('Error in getById: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to get product by id: $e'),
      );
    }
  }

  @override
  Future<Result<DefaultReturnEntity>> deleteProduct(String id) async {
    try {
      final result = await _productsDatasource.deleteProduct(id);

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao deletar produto',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      return Result.ok(
        DefaultReturnModel.fromMap(result.data as Map<String, dynamic>),
      );
    } on Exception catch (e) {
      log('Error in deleteProduct: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to delete product: $e'),
      );
    }
  }

  @override
  Future<Result<DefaultReturnEntity>> updateProduct(ProductDto dto) async {
    try {
      final result = await _productsDatasource.updateProduct(dto);

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao atualizar produto',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      return Result.ok(
        DefaultReturnModel.fromMap(result.data as Map<String, dynamic>),
      );
    } on Exception catch (e) {
      log('Error in updateProduct: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to update product: $e'),
      );
    }
  }

  @override
  Future<Result<List<ProductEntity>>> getLatestProducts() async {
    try {
      final result = await _productsDatasource.getLatestProducts();

      if (!result.isSuccess && result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter últimos produtos',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final products = (result.data as List<dynamic>)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return Result.ok(products);
    } on Exception catch (e) {
      log('Error in getLatestProducts: $e');
      return Result.error(
        Failure(errorMessage: 'Failed to get latest products: $e'),
      );
    }
  }
}
