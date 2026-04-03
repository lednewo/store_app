import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:base_app/domain/dto/order_dto.dart';

class OrderDatasource {
  OrderDatasource({required HttpService httpService})
    : _httpService = httpService;

  final HttpService _httpService;

  //TODO: Implementar paginacao
  Future<BaseResponse> getOrders() async {
    final response = await _httpService.get('/orders/getAllPageable');
    return response;
  }

  Future<BaseResponse> createOrder(OrderDto dto) async {
    final response = await _httpService.post(
      '/orders/create',
      data: dto.toJson(),
    );
    return response;
  }
}
