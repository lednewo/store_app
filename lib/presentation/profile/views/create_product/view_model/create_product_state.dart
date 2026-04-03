import 'package:flutter/foundation.dart';

@immutable
sealed class CreateProductState {
  const CreateProductState();
}

class CreateProductInitial extends CreateProductState {
  const CreateProductInitial();
}

class CreateProductLoading extends CreateProductState {
  const CreateProductLoading();
}

class CreateProductSuccess extends CreateProductState {
  const CreateProductSuccess(this.message);
  final String message;
}

class CreateProductError extends CreateProductState {
  const CreateProductError(this.message);
  final String message;
}
