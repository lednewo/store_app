import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/product_dto.dart';

class ProductsDatasource {
  ProductsDatasource({required HttpService httpService})
    : _httpService = httpService;
  final HttpService _httpService;

  Future<BaseResponse> getProducts(PaginationDto dto) async {
    final response = await _httpService.get(
      '/products/getAllPageable',
      queryParameters: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> createProduct(ProductDto dto) async {
    final response = await _httpService.post(
      '/products/create',
      data: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> getById(String id) async {
    final response = await _httpService.get(
      '/products/details',
      queryParameters: {'id': id},
    );
    return response;
  }
}
