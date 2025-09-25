import 'package:mxpertz_test/core/enums/error_type.dart';

class AppError implements Exception {
  const AppError({
    required this.message,
    required this.type,
    this.originalError,
    this.stackTrace,
    this.code,
    this.statusCode,
  });

  final String message;
  final ErrorType type;
  final dynamic originalError;
  final StackTrace? stackTrace;
  final String? code;
  final int? statusCode;

  bool get isRetryAble {
    return type == ErrorType.network ||
        type == ErrorType.timeout ||
        type == ErrorType.server ||
        (type == ErrorType.unknown && originalError is! FormatException);
  }

  @override
  String toString() {
    return 'AppError (Type: $type): $message'
        '${code != null ? ' (Code: $code)' : ''}'
        '${statusCode != null ? ' (Status: $statusCode)' : ''}'
        '${originalError != null ? '\nOriginal Error: $originalError' : ''}'
        '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}';
  }
}
