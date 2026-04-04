import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/update_order_status.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/order_detail_entity.dart';
import 'package:base_app/domain/entities/paginated_orders_entity.dart';
import 'package:base_app/domain/entities/solds_quantity_entity.dart';

abstract class OrderRepository {
  Future<Result<PaginatedOrdersEntity>> fetchOrders(PaginationDto dto);
  Future<Result<DefaultReturnEntity>> createOrder(OrderDto dto);
  Future<Result<DefaultReturnEntity>> updateStatusOrder(UpdateOrderStatus dto);
  Future<Result<OrderDetailEntity>> getOrderDetails(String id);
  Future<Result<DefaultReturnEntity>> deleteOrder(String id);
  Future<Result<List<SoldsQuantityEntity>>> getSoldQuantity();
}
