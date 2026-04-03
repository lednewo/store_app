import 'package:base_app/common/widgets/app_dialog.dart';
import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/l10n/l10n.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.productDetailsTitle),
        centerTitle: true,
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
