import 'package:base_app/domain/entities/solds_quantity_entity.dart';
import 'package:base_app/domain/entities/top_selling_products_entity.dart';

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
  const DashboardLoadedState({
    required this.soldsQuantity,
    this.topProducts = const [],
  });
  final List<SoldsQuantityEntity> soldsQuantity;
  final List<TopSellingProductsEntity> topProducts;

  DashboardLoadedState copyWith({
    List<SoldsQuantityEntity>? soldsQuantity,
    List<TopSellingProductsEntity>? topProducts,
  }) {
    return DashboardLoadedState(
      soldsQuantity: soldsQuantity ?? this.soldsQuantity,
      topProducts: topProducts ?? this.topProducts,
    );
  }
}

class TopProductsLoadedState extends DashboardState {
  const TopProductsLoadedState(this.topProducts);
  final List<TopSellingProductsEntity> topProducts;
}
