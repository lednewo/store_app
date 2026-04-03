import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/entities/cart_item_entity.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_cubit.dart';
import 'package:base_app/presentation/products/view/cart/view_model/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final CartCubit _cubit = AppInjector.inject.get<CartCubit>();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cartTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocConsumer<CartCubit, CartState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is CartOrderSuccess) {
              _cubit.clearCart();
              context.pop();
              AppSnackbar.showSuccess(context, message: state.message);
            }
            if (state is CartOrderError) {
              AppSnackbar.showError(context, message: state.message);
            }
          },
          builder: (context, state) {
            final List<CartItemEntity> items = switch (state) {
              CartUpdated(:final items) => items,
              CartOrdering(:final items) => items,
              CartOrderError(:final items) => items,
              _ => const <CartItemEntity>[],
            };

            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 72,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.cartEmptyMessage,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            final cartState = state;
            final double total = switch (cartState) {
              CartUpdated() => cartState.total,
              CartOrdering() => CartUpdated(cartState.items).total,
              CartOrderError() => CartUpdated(cartState.items).total,
              _ => 0.0,
            };

            final isOrdering = state is CartOrdering;

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.productName,
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${l10n.cartColorLabel}: ${item.cor}  •  '
                                      '${l10n.cartSizeLabel}: ${item.tamanho}',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _QuantityControl(
                                          quantidade: item.quantidade,
                                          onDecrement: () =>
                                              _cubit.updateQuantity(
                                                item.productId,
                                                item.cor,
                                                item.tamanho,
                                                item.quantidade - 1,
                                              ),
                                          onIncrement: () =>
                                              _cubit.updateQuantity(
                                                item.productId,
                                                item.cor,
                                                item.tamanho,
                                                item.quantidade + 1,
                                              ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'R\$ ${item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                          style: textTheme.titleSmall?.copyWith(
                                            color: colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: colorScheme.error,
                                ),
                                onPressed: () => _cubit.removeItem(
                                  item.productId,
                                  item.cor,
                                  item.tamanho,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    border: Border(
                      top: BorderSide(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    16,
                    12,
                    16,
                    MediaQuery.paddingOf(context).bottom + 12,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.cartTotalLabel,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: isOrdering
                              ? null
                              : () => _cubit.checkout(),
                          child: isOrdering
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(l10n.cartCheckoutButton),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  const _QuantityControl({
    required this.quantidade,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantidade;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        _CircleIconButton(
          icon: Icons.remove,
          onTap: onDecrement,
          color: colorScheme.outlineVariant,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantidade',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        _CircleIconButton(
          icon: Icons.add,
          onTap: onIncrement,
          color: colorScheme.primary,
          iconColor: colorScheme.onPrimary,
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.color,
    this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.15),
          border: Border.all(color: color),
        ),
        child: Icon(icon, size: 14, color: iconColor ?? color),
      ),
    );
  }
}
