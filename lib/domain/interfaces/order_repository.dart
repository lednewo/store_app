import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/paginated_orders_entity.dart';

abstract class OrderRepository {
  Future<Result<PaginatedOrdersEntity>> fetchOrders();
  Future<Result<DefaultReturnEntity>> createOrder(OrderDto dto);
}
