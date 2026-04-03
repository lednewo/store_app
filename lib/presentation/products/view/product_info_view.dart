import 'package:base_app/common/utils/login_detect.dart';
import 'package:base_app/common/widgets/app_dialog.dart';
import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/config/routes/app_routes.dart';
import 'package:base_app/domain/entities/cart_item_entity.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_cubit.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_state.dart';
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
      builder: (sheetContext) => _AddToCartSheet(
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
                onEdit: () {},
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

class _AddToCartSheet extends StatefulWidget {
  const _AddToCartSheet({
    required this.product,
    required this.onConfirm,
  });

  final ProductEntity product;
  final void Function(CartItemEntity item) onConfirm;

  @override
  State<_AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<_AddToCartSheet> {
  int? _selectedSizeIndex;
  int? _selectedColorIndex;
  int _quantidade = 1;

  bool get _canConfirm =>
      _selectedSizeIndex != null && _selectedColorIndex != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final product = widget.product;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cartAddTitle,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            product.name,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          if (product.sizes.isNotEmpty) ...[
            Text(
              l10n.cartSizeLabel,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(product.sizes.length, (i) {
                final isSelected = _selectedSizeIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSizeIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                    child: Text(
                      product.sizes[i].toString(),
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (product.colors.isNotEmpty) ...[
            Text(
              l10n.cartColorLabel,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(product.colors.length, (i) {
                final isSelected = _selectedColorIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColorIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      product.colors[i],
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            l10n.cartQuantityLabel,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _SheetCircleButton(
                icon: Icons.remove,
                onTap: _quantidade > 1
                    ? () => setState(() => _quantidade--)
                    : null,
                color: colorScheme.outlineVariant,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '$_quantidade',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _SheetCircleButton(
                icon: Icons.add,
                onTap: () => setState(() => _quantidade++),
                color: colorScheme.primary,
                iconColor: colorScheme.onPrimary,
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _canConfirm
                  ? () {
                      widget.onConfirm(
                        CartItemEntity(
                          productId: product.id,
                          productName: product.name,
                          price: product.price,
                          cor: product.colors[_selectedColorIndex!],
                          tamanho: product.sizes[_selectedSizeIndex!],
                          quantidade: _quantidade,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text(l10n.cartAddButton),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetCircleButton extends StatelessWidget {
  const _SheetCircleButton({
    required this.icon,
    required this.color,
    this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap != null
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.05),
          border: Border.all(
            color: onTap != null ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null
              ? (iconColor ?? color)
              : color.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
