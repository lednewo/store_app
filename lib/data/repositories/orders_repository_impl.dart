import 'package:base_app/config/error/failure.dart';
import 'package:base_app/config/error/result_pattern.dart';
import 'package:base_app/data/datasources/order/order_datasource.dart';
import 'package:base_app/data/models/default_return_model.dart';
import 'package:base_app/data/models/order_detail_model.dart';
import 'package:base_app/data/models/paginated_orders_model.dart';
import 'package:base_app/domain/dto/order_dto.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/update_order_status.dart';
import 'package:base_app/domain/entities/default_return_entity.dart';
import 'package:base_app/domain/entities/order_detail_entity.dart';
import 'package:base_app/domain/entities/paginated_orders_entity.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';

class OrdersRepositoryImpl implements OrderRepository {
  OrdersRepositoryImpl({required OrderDatasource orderDatasource})
    : _orderDatasource = orderDatasource;

  final OrderDatasource _orderDatasource;

  @override
  Future<Result<PaginatedOrdersEntity>> fetchOrders(PaginationDto dto) async {
    try {
      final result = await _orderDatasource.getOrders(dto);

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

  @override
  Future<Result<DefaultReturnEntity>> updateStatusOrder(
    UpdateOrderStatus dto,
  ) async {
    try {
      final result = await _orderDatasource.updateStatusOrder(dto);

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage:
                result.message ?? 'Erro ao atualizar status do pedido',
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

  @override
  Future<Result<OrderDetailEntity>> getOrderDetails(String id) async {
    try {
      final result = await _orderDatasource.getOrderDetails(id);

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao obter detalhes do pedido',
            responseStatus: result.status,
            statusCode: result.statusCode,
          ),
        );
      }

      final orderDetails = OrderDetailModel.fromJson(
        result.data as Map<String, dynamic>,
      );
      return Result.ok(orderDetails);
    } on Exception catch (e) {
      return Result.error(
        Failure(
          errorMessage: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Result<DefaultReturnEntity>> deleteOrder(String id) async {
    try {
      final result = await _orderDatasource.deleteOrder(id);

      if (!result.isSuccess || result.data == null) {
        return Result.error(
          Failure(
            errorMessage: result.message ?? 'Erro ao deletar pedido',
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
