import 'package:base_app/domain/dto/pagination_dto.dart';
import 'package:base_app/domain/dto/product_dto.dart';
import 'package:base_app/domain/enum/status_enum.dart';
import 'package:base_app/domain/interfaces/products_repository.dart';
import 'package:bloc/bloc.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit({required ProductsRepository repository})
    : _repository = repository,
      super(const ProductsInitial());

  final ProductsRepository _repository;

  bool hasMore = false;
  int totalPages = 0;
  int currentPage = 0;
  String? currentName;
  String? currentModel;
  String? currentBrand;
  double? currentMinPrice;
  double? currentMaxPrice;
  StatusEnum? currentStatus;

  bool get canGoPrevius => currentPage > 0;
  bool get canGoNext => currentPage + 1 < totalPages;

  Future<void> fetchProducts(PaginationDto dto) async {
    emit(const ProductsLoading());

    final result = await _repository.getProducts(dto);
    currentPage = dto.page;
    currentName = dto.name;
    currentModel = dto.model;
    currentBrand = dto.brand;
    currentMinPrice = dto.minPrice;
    currentMaxPrice = dto.maxPrice;
    currentStatus = dto.status;

    result.when(
      ok: (success) {
        hasMore =
            success.data.length == dto.size && currentPage < totalPages - 1;
        totalPages = success.totalPages;

        emit(ProductsSuccess(success));
      },
      error: (error) {
        emit(ProductsError(error.toString()));
      },
    );
  }

  Future<void> fetchLatestProducts() async {
    emit(const ProductsLoading());

    final result = await _repository.getLatestProducts();

    result.when(
      ok: (success) {
        emit(LatestProductsSuccess(success));
      },
      error: (error) {
        emit(LatestProductsError(error.toString()));
      },
    );
  }

  Future<void> getById(String id) async {
    emit(const ProductsLoading());

    final result = await _repository.getById(id);

    result.when(
      ok: (success) {
        emit(ProductDetailsSuccess(success));
      },
      error: (error) {
        emit(ProductsError(error.toString()));
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(const ProductsLoading());

    final result = await _repository.deleteProduct(id);

    result.when(
      ok: (success) {
        emit(ProductDeleteSuccess(success.message));
      },
      error: (error) {
        emit(ProductDeleteError(error.toString()));
      },
    );
  }

  Future<void> updateProduct(ProductDto dto) async {
    emit(const ProductsLoading());

    final result = await _repository.updateProduct(dto);

    result.when(
      ok: (success) {
        emit(ProductUpdateSuccess(success.message));
      },
      error: (error) {
        emit(ProductsError(error.toString()));
      },
    );
  }
}
