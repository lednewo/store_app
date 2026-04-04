import 'package:base_app/domain/entities/solds_quantity_entity.dart';

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitialState extends DashboardState {
  const DashboardInitialState();
}

class DashboardLoadingState extends DashboardState {
  const DashboardLoadingState();
}

class DashboardErrorState extends DashboardState {
  const DashboardErrorState(this.message);
  final String message;
}

class DashboardLoadedState extends DashboardState {
  const DashboardLoadedState(this.soldsQuantity);
  final List<SoldsQuantityEntity> soldsQuantity;
}
