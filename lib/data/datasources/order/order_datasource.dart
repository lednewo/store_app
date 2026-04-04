import 'package:base_app/common/services/http/http_service.dart';
import 'package:base_app/common/utils/base_response.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/update_order_status.dart';

class OrderDatasource {
  OrderDatasource({required HttpService httpService})
    : _httpService = httpService;

  final HttpService _httpService;

  //TODO: Implementar paginacao
  Future<BaseResponse> getOrders(PaginationDto dto) async {
    final response = await _httpService.get(
      '/orders/getAllPageable',
      queryParameters: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> createOrder(OrderDto dto) async {
    final response = await _httpService.post(
      '/orders/create',
      data: dto.toJson(),
    );
    return response;
  }

  Future<BaseResponse> updateStatusOrder(UpdateOrderStatus dto) async {
    final response = await _httpService.patch(
      '/orders/updateStatus',
      queryParameters: dto.toMap(),
    );
    return response;
  }

  Future<BaseResponse> getOrderDetails(String id) async {
    final response = await _httpService.get(
      '/orders/getById',
      queryParameters: {'orderId': id},
    );
    return response;
  }

  Future<BaseResponse> deleteOrder(String id) async {
    final response = await _httpService.delete(
      '/orders/delete',
      queryParameters: {'orderId': id},
    );
    return response;
  }

  Future<BaseResponse> getSoldQuantity() async {
    final response = await _httpService.get(
      '/orders/soldQuantityLast3Months',
    );
    return response;
  }
}
