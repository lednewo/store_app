import 'package:base_app/domain/interfaces/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:base_app/presentation/dashboard/view_model/dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._orderRepository) : super(const DashboardInitialState());

  final OrderRepository _orderRepository;

  Future<void> loadDashboardData() async {
    emit(const DashboardLoadingState());
    final result = await _orderRepository.getSoldQuantity();

    result.when(
      ok: (success) {
        emit(DashboardLoadedState(success));
      },
      error: (failure) {
        emit(DashboardErrorState(failure.toString()));
      },
    );
  }
}
