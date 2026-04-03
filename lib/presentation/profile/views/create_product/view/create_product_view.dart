import 'dart:async';

import 'package:base_app/common/utils/extensions/real_extension.dart';
import 'package:base_app/common/utils/formatters/real_formatter.dart';
import 'package:base_app/common/widgets/app_button.dart';
import 'package:base_app/common/widgets/app_snackbar.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/entities/product_entity.dart';
import 'package:base_app/domain/enum/audience_enum.dart';
import 'package:base_app/domain/enum/gender_enum.dart';
import 'package:base_app/domain/enum/status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_cubit.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_state.dart';
import 'package:base_app/presentation/profile/views/create_product/widgets/form_card.dart';
import 'package:base_app/presentation/profile/views/create_product/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateProductView extends StatefulWidget {
  const CreateProductView({super.key, this.productEntity});

  final ProductEntity? productEntity;

  @override
  State<CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<CreateProductView> {
  final CreateProductCubit _cubit = AppInjector.inject
      .get<CreateProductCubit>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizesController = TextEditingController();
  final _colorsController = TextEditingController();

  GenderEnum _selectedGender = GenderEnum.unisex;
  AudienceEnum _selectedAudience = AudienceEnum.adult;
  StatusEnum _selectedStatus = StatusEnum.active;

  late final bool isEditMode;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.productEntity != null;

    if (isEditMode) {
      final product = widget.productEntity!;
      _nameController.text = product.name;
      _modelController.text = product.model;
      _brandController.text = product.brand;
      _descriptionController.text = product.description;
      _priceController.text = product.price.toReal();
      _sizesController.text = product.sizes.join(', ');
      _colorsController.text = product.colors.join(', ');
      _selectedGender = GenderEnum.fromString(product.gender.label);
      _selectedAudience = AudienceEnum.fromString(product.audience.label);
      _selectedStatus = StatusEnum.fromString(product.status.label);
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    _nameController.dispose();
    _modelController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sizesController.dispose();
    _colorsController.dispose();
    super.dispose();
  }

  double parseRealToDouble(String text) {
    if (text.isEmpty) return 0.0;
    final cleaned = text
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(cleaned) ?? 0.0;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final sizesRaw = _sizesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final sizes = sizesRaw.map(int.tryParse).whereType<int>().toList();

    final colors = _colorsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final price = parseRealToDouble(_priceController.text);

    if (isEditMode) {
      unawaited(
        _cubit.updateProduct(
          ProductDto(
            id: widget.productEntity!.id,
            name: _nameController.text.trim(),
            model: _modelController.text.trim(),
            brand: _brandController.text.trim(),
            description: _descriptionController.text.trim(),
            gender: _selectedGender.label,
            audience: _selectedAudience.value,
            sizes: sizes,
            colors: colors,
            price: price,
            status: _selectedStatus.value,
            urlImages: widget.productEntity!.urlImages,
          ),
        ),
      );
    } else {
      unawaited(
        _cubit.createProduct(
          ProductDto(
            name: _nameController.text.trim(),
            model: _modelController.text.trim(),
            brand: _brandController.text.trim(),
            description: _descriptionController.text.trim(),
            gender: _selectedGender.label,
            audience: _selectedAudience.value,
            sizes: sizes,
            colors: colors,
            price: price,
            status: _selectedStatus.value,
            urlImages: [],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.createProductTitle,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocListener<CreateProductCubit, CreateProductState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is CreateProductSuccess) {
              AppSnackbar.showSuccess(context, message: state.message);
              context.pop();
            } else if (state is CreateProductError) {
              AppSnackbar.showError(context, message: state.message);
            }
            if (state is UpdateProductSuccess) {
              AppSnackbar.showSuccess(context, message: state.message);
              context.pop(true);
            } else if (state is UpdateProductError) {
              AppSnackbar.showError(context, message: state.message);
            }
          },
          child: BlocBuilder<CreateProductCubit, CreateProductState>(
            bloc: _cubit,
            builder: (context, state) {
              final isLoading = state is CreateProductLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        icon: Icons.inventory_2_outlined,
                        label: l10n.createProductBasicInfoSectionLabel,
                      ),
                      const SizedBox(height: 12),
                      FormCard(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductNameLabel,
                              prefixIcon: const Icon(
                                Icons.label_outline_rounded,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductNameRequiredMessage;
                              }
                              return null;
                            },
                          ),
                          _FieldDivider(),
                          TextFormField(
                            controller: _modelController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductModelLabel,
                              prefixIcon: const Icon(Icons.style_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductModelRequiredMessage;
                              }
                              return null;
                            },
                          ),
                          _FieldDivider(),
                          TextFormField(
                            controller: _brandController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductBrandLabel,
                              prefixIcon: const Icon(Icons.business_outlined),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductBrandRequiredMessage;
                              }
                              return null;
                            },
                          ),
                          _FieldDivider(),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductDescriptionLabel,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(bottom: 48),
                                child: Icon(Icons.notes_rounded),
                              ),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SectionHeader(
                        icon: Icons.sell_outlined,
                        label: l10n.createProductPricingSectionLabel,
                      ),
                      const SizedBox(height: 12),
                      FormCard(
                        children: [
                          TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductPriceLabel,
                              prefixIcon: const Icon(
                                Icons.attach_money_rounded,
                              ),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [RealFormatter()],
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductPriceRequiredMessage;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      SectionHeader(
                        icon: Icons.tune_rounded,
                        label: l10n.createProductVariationsSectionLabel,
                      ),
                      const SizedBox(height: 12),
                      FormCard(
                        children: [
                          TextFormField(
                            controller: _sizesController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductSizesLabel,
                              prefixIcon: const Icon(Icons.straighten_outlined),
                              helperText: l10n.createProductSizesHelperText,
                            ),
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductSizesRequiredMessage;
                              }
                              final parts = value
                                  .split(',')
                                  .map((s) => s.trim())
                                  .where((s) => s.isNotEmpty)
                                  .toList();
                              final allValid = parts.every(
                                (s) => int.tryParse(s) != null,
                              );
                              if (!allValid) {
                                return l10n.createProductSizesInvalidMessage;
                              }
                              return null;
                            },
                          ),
                          _FieldDivider(),
                          TextFormField(
                            controller: _colorsController,
                            decoration: InputDecoration(
                              labelText: l10n.createProductColorsLabel,
                              prefixIcon: const Icon(Icons.palette_outlined),
                              helperText: l10n.createProductColorsHelperText,
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return l10n.createProductColorsRequiredMessage;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SectionHeader(
                        icon: Icons.category_outlined,
                        label: l10n.createProductClassificationSectionLabel,
                      ),
                      const SizedBox(height: 12),
                      FormCard(
                        children: [
                          DropdownButtonFormField<GenderEnum>(
                            initialValue: _selectedGender,
                            decoration: InputDecoration(
                              labelText: l10n.createProductGenderLabel,
                              prefixIcon: const Icon(Icons.wc_outlined),
                            ),
                            items: GenderEnum.values
                                .map(
                                  (g) => DropdownMenuItem(
                                    value: g,
                                    child: Text(g.value),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedGender = value);
                              }
                            },
                          ),
                          _FieldDivider(),
                          DropdownButtonFormField<AudienceEnum>(
                            initialValue: _selectedAudience,
                            decoration: InputDecoration(
                              labelText: l10n.createProductAudienceLabel,
                              prefixIcon: const Icon(
                                Icons.people_outline_rounded,
                              ),
                            ),
                            items: AudienceEnum.values
                                .map(
                                  (a) => DropdownMenuItem(
                                    value: a,
                                    child: Text(a.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedAudience = value);
                              }
                            },
                          ),
                          _FieldDivider(),
                          DropdownButtonFormField<StatusEnum>(
                            initialValue: _selectedStatus,
                            decoration: InputDecoration(
                              labelText: l10n.createProductStatusLabel,
                              prefixIcon: const Icon(Icons.toggle_on_outlined),
                            ),
                            items: StatusEnum.values
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.label),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedStatus = value);
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      AppButton(
                        label: isEditMode
                            ? l10n.editProductButton
                            : l10n.createProductButton,
                        onTap: isLoading ? null : _submit,
                        isFullWidth: true,
                        isLoading: isLoading,
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FieldDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
    );
  }
}
