import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';
import 'package:base_app/presentation/profile/views/create_product/view_model/create_product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit(this._productsRepository)
    : super(const CreateProductInitial());

  final ProductsRepository _productsRepository;

  Future<void> createProduct(ProductDto dto) async {
    emit(const CreateProductLoading());

    final result = await _productsRepository.createProduct(dto);

    result.when(
      ok: (data) => emit(CreateProductSuccess(data.message)),
      error: (e) => emit(CreateProductError(e.toString())),
    );
  }
}
