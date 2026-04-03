import 'package:base_app/common/utils/base_response.dart';
import 'package:flutter/foundation.dart';

class Failure implements Exception {
  Failure({
    ResponseStatus? responseStatus,
    StackTrace? stackTrace,
    int? statusCode,
    String? label,
    dynamic exception,
    this.errorMessage = '',
  }) {
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
  final String errorMessage;

  @override
  String toString() => errorMessage;
}
