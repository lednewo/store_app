import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/common/widgets/app_dialog.dart';
import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_cubit.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_state.dart';
import 'package:base_app/presentation/products/view/cart/widgets/add_to_cart_sheet.dart';
import 'package:base_app/presentation/products/view_model/products_cubit.dart';
import 'package:base_app/presentation/products/view_model/products_state.dart';
import 'package:base_app/presentation/products/widgets/product_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProductInfoView extends StatefulWidget {
  const ProductInfoView({
    required this.productId,
    super.key,
  });
  final String productId;

  @override
  State<ProductInfoView> createState() => _ProductInfoViewState();
}

class _ProductInfoViewState extends State<ProductInfoView> {
  final ProductsCubit _productsCubit = AppInjector.inject.get<ProductsCubit>();
  final CartCubit _cartCubit = AppInjector.inject.get<CartCubit>();

  @override
  void initState() {
    super.initState();
    _productsCubit.getById(widget.productId);
  }

  @override
  void dispose() {
    _productsCubit.close();
    super.dispose();
  }

  Future<void> _showDeleteProduct() async {
    final confirmed = await AppDialog.show(
      context: context,
      title: 'Excluir produto?',
      description: 'Esta ação não pode ser desfeita.',
      confirmLabel: 'Excluir',
      cancelLabel: context.l10n.cancelButton,
      isDangerous: true,
    );

    if (confirmed) {
      await _productsCubit.deleteProduct(widget.productId);
    }
  }

  void _showAddToCartSheet(ProductEntity product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => AddToCartSheet(
        product: product,
        onConfirm: (item) {
          _cartCubit.addItem(item);
          AppSnackbar.showSuccess(
            context,
            message: context.l10n.cartItemAddedMessage,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetailsTitle),
        centerTitle: true,
        actions: [
          if (LoginDetect.isCliente)
            BlocBuilder<CartCubit, CartState>(
              bloc: _cartCubit,
              builder: (context, cartState) {
                final count = cartState is CartUpdated
                    ? cartState.itemCount
                    : 0;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () => context.push(AppRoutes.cart),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              color: colorScheme.onError,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<ProductsCubit, ProductsState>(
          bloc: _productsCubit,
          listener: (context, state) {
            if (state is ProductDeleteSuccess) {
              context.pop();
              AppSnackbar.showSuccess(
                context,
                message: state.message,
              );
            }

            if (state is ProductDeleteError) {
              AppSnackbar.showError(
                context,
                message: state.message,
              );
              _productsCubit.getById(widget.productId);
            }
          },
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProductsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => _productsCubit.getById(widget.productId),
                      child: Text(l10n.retryButton),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductDetailsSuccess) {
              return ProductInfoContent(
                product: state.product,
                onEdit: () async {
                  final bool? result = await context.push<bool>(
                    AppRoutes.createProduct,
                    extra: state.product,
                  );
                  if (result == true) {
                    _productsCubit.getById(widget.productId);
                  }
                },
                onDelete: _showDeleteProduct,
                onAddToCart: () => _showAddToCartSheet(state.product),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
