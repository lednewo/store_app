import 'dart:async';

import 'package:base_app/common/utils/formatters/real_formatter.dart';
import 'package:base_app/config/inject/app_injector.dart';
import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/enum/audience_enum.dart';
import 'package:base_app/domain/enum/gender_enum.dart';
import 'package:base_app/domain/enum/status_enum.dart';
import 'package:base_app/l10n/l10n.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_cubit.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateProductView extends StatefulWidget {
  const CreateProductView({super.key});

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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createProductTitle),
      ),
      body: SafeArea(
        child: BlocListener<CreateProductCubit, CreateProductState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is CreateProductSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.pop();
            } else if (state is CreateProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<CreateProductCubit, CreateProductState>(
            bloc: _cubit,
            builder: (context, state) {
              final isLoading = state is CreateProductLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductNameLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.createProductNameRequiredMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _modelController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductModelLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.createProductModelRequiredMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _brandController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductBrandLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.createProductBrandRequiredMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductDescriptionLabel,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductPriceLabel,
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _sizesController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductSizesLabel,
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
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _colorsController,
                        decoration: InputDecoration(
                          labelText: l10n.createProductColorsLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.createProductColorsRequiredMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<GenderEnum>(
                        initialValue: _selectedGender,
                        decoration: InputDecoration(
                          labelText: l10n.createProductGenderLabel,
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
                      const SizedBox(height: 12),
                      DropdownButtonFormField<AudienceEnum>(
                        initialValue: _selectedAudience,
                        decoration: InputDecoration(
                          labelText: l10n.createProductAudienceLabel,
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
                      const SizedBox(height: 12),
                      DropdownButtonFormField<StatusEnum>(
                        initialValue: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: l10n.createProductStatusLabel,
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.createProductButton),
                      ),
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
