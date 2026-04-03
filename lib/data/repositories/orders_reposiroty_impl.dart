import 'package:base_app/config/error/failure.dart';
import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/order/order_datasource.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/data/models/paginated_orders_model.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/paginated_orders_entity.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';

class OrdersReposirotyImpl implements OrderRepository {
  OrdersReposirotyImpl({required OrderDatasource orderDatasource})
    : _orderDatasource = orderDatasource;

  final OrderDatasource _orderDatasource;

  @override
  Future<Result<PaginatedOrdersEntity>> fetchOrders() async {
    try {
      final result = await _orderDatasource.getOrders();

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter pedidos',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final orders = PaginatedOrdersModel.fromJson(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(orders);
    } on Exception catch (e) {
      return Result.error(
        Failure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<DefaultReturnEntity>> createOrder(OrderDto dto) async {
    try {
      final result = await _orderDatasource.createOrder(dto);

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao criar pedido',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final defaultReturn = DefaultReturnModel.fromMap(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(defaultReturn);
    } on Exception catch (e) {
      return Result.error(
        Failure(
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
