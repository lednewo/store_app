import 'package:base_app/domain/entities/default_return_entity.dart';

class DefaultReturnModel extends DefaultReturnEntity {
  DefaultReturnModel({required super.message, required super.statusCode});

  factory DefaultReturnModel.fromMap(Map<String, dynamic> map) {
    return DefaultReturnModel(
      message: map['message'] as String? ?? '',
      statusCode: map['statusCode'] as String? ?? '',
    );
  }
}
