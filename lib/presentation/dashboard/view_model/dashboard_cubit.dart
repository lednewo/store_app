import 'package:base_app/domain/dto/filter_month_year_dto.dart';
import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';
import 'package:base_app/presentation/dashboard/view_model/dashboard_state.dart';
import 'package:bloc/bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._orderRepository, this._productsRepository)
    : super(const DashboardInitialState());

  final OrderRepository _orderRepository;
  final ProductsRepository _productsRepository;

  Future<void> loadDashboardData() async {
    emit(const DashboardLoadingState());

    final result = await _orderRepository.getSoldQuantity();

    result.when(
      ok: (success) {
        final current = state;
        emit(
          DashboardLoadedState(
            soldsQuantity: success,
            topProducts: current is DashboardLoadedState
                ? current.topProducts
                : const [],
          ),
        );
      },
      error: (failure) {
        emit(DashboardErrorState(failure.toString()));
      },
    );
  }

  Future<void> loadTopProducts(FilterMonthYearDto dto) async {
    final result = await _productsRepository.getTop3Products(dto);

    result.when(
      ok: (success) {
        final current = state;
        emit(
          DashboardLoadedState(
            soldsQuantity: current is DashboardLoadedState
                ? current.soldsQuantity
                : const [],
            topProducts: success,
          ),
        );
      },
      error: (failure) {
        emit(DashboardErrorState(failure.toString()));
      },
    );
  }
}
