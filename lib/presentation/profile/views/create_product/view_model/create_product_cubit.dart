import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit(this._productsRepository)
    : super(const CreateProductInitial());

  final ProductsRepository _productsRepository;

  Future<void> createProduct({
    required String name,
    required String model,
    required String brand,
    required String description,
    required String gender,
    required String audience,
    required List<int> sizes,
    required List<String> colors,
    required double price,
    required String status,
    List<String>? urlImages,
  }) async {
    emit(const CreateProductLoading());

    final dto = ProductDto(
      name: name,
      model: model,
      brand: brand,
      description: description,
      gender: gender,
      audience: audience,
      sizes: sizes,
      colors: colors,
      price: price,
      status: status,
      urlImages: urlImages,
    );

    final result = await _productsRepository.createProduct(dto);

    result.when(
      ok: (data) => emit(CreateProductSuccess(data.message)),
      error: (e) => emit(CreateProductError('$e')),
    );
  }
}
