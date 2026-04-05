import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/filter_month_year_dto.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/dashboard/view_model/dashboard_cubit.dart';
import 'package:base_app/presentation/dashboard/view_model/dashboard_state.dart';
import 'package:base_app/presentation/dashboard/widgets/solds_bar_chart.dart';
import 'package:base_app/presentation/dashboard/widgets/top_product_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardTabContent extends StatefulWidget {
  const DashboardTabContent({super.key});

  @override
  State<DashboardTabContent> createState() => _DashboardTabContentState();
}

class _DashboardTabContentState extends State<DashboardTabContent> {
  final DashboardCubit _cubit = AppInjector.inject.get<DashboardCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.loadDashboardData();
    _cubit.loadTopProducts(FilterMonthYearDto());
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dashboardTitle),
        centerTitle: true,
      ),
      body: BlocConsumer<DashboardCubit, DashboardState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is DashboardErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DashboardLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardErrorState) {
            return Center(
              child: AppButton(
                icon: Icons.refresh_sharp,
                label: l10n.dashboardRetryButton,
                onTap: _cubit.loadDashboardData,
              ),
            );
          }

          if (state is DashboardLoadedState) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  l10n.dashboardSoldsChartTitle,
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 240,
                  child: SoldsBarChart(data: state.soldsQuantity),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.dashboardTopProductsTitle,
                      style: textTheme.titleMedium,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.filter_list_alt,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (state.topProducts.isEmpty)
                  Center(child: Text(l10n.dashboardNoProductsFound))
                else
                  ...state.topProducts
                      .take(3)
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (entry) => TopProductTile(
                          rank: entry.key + 1,
                          product: entry.value,
                        ),
                      ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
