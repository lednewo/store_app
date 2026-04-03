import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/paginated_products_entity.dart';
import 'package:base_app/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  /// Cria um novo produto
  Future<Result<DefaultReturnEntity>> createProduct(ProductDto dto);
  Future<Result<PaginatedProductsEntity>> getProducts(PaginationDto dto);
  Future<Result<ProductEntity>> getById(String id);
  Future<Result<DefaultReturnEntity>> updateProduct(ProductDto dto);
  Future<Result<DefaultReturnEntity>> deleteProduct(String id);
  Future<Result<List<ProductEntity>>> getLatestProducts();
}
