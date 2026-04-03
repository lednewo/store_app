import 'dart:async';

import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/products/view_model/products_cubit.dart';
import 'package:base_app/presentation/products/view_model/products_state.dart';
import 'package:base_app/presentation/products/widgets/pagination_controls.dart';
import 'package:base_app/presentation/products/widgets/product_card_widget.dart';
import 'package:base_app/presentation/products/widgets/product_horizontal_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ProductsCubit _productsCubit = AppInjector.inject.get<ProductsCubit>();
  List<ProductEntity> _latestProducts = [];

  @override
  void initState() {
    super.initState();
    unawaited(_productsCubit.fetchLatestProducts());
    unawaited(_productsCubit.fetchProducts(PaginationDto(page: 0)));
  }

  void _goToPage(int page) {
    unawaited(
      _productsCubit.fetchProducts(PaginationDto(page: page)),
    );
  }

  @override
  void dispose() {
    unawaited(_productsCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.productsTabLabel)),
      body: SafeArea(
        child: BlocConsumer<ProductsCubit, ProductsState>(
          bloc: _productsCubit,
          listener: (context, state) {
            if (state is LatestProductsSuccess) {
              setState(() => _latestProducts = state.latestProducts);
            }
            if (state is ProductsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is ProductDeleteSuccess) {
              unawaited(_productsCubit.fetchProducts(PaginationDto(page: 0)));
            }
          },
          builder: (context, state) {
            if (state is ProductsLoading || state is LatestProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsSuccess) {
              final products = state.products.data;

              if (products.isEmpty && _latestProducts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.productsTabLabel,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        unawaited(_productsCubit.fetchLatestProducts());
                        await _productsCubit.fetchProducts(
                          PaginationDto(page: 0),
                        );
                      },
                      child: CustomScrollView(
                        slivers: [
                          if (_latestProducts.isNotEmpty) ...[
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  8,
                                ),
                                child: Text(
                                  l10n.latestProductsLabel,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 220,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _latestProducts.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) => SizedBox(
                                    width: 280,
                                    height: 180,
                                    child: ProductHorizontalCardWidget(
                                      product: _latestProducts[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 16),
                            ),
                          ],
                          if (products.isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              sliver: SliverToBoxAdapter(
                                child: Text(
                                  l10n.allProductsLabel,
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.72,
                                  ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => ProductCardWidget(
                                  product: products[index],
                                ),
                                childCount: products.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PaginationControls(
                    cubit: _productsCubit,
                    onPageChanged: _goToPage,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
