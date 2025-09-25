import 'package:flutter/material.dart';
import 'package:mxpertz_test/core/enums/error_type.dart';
import 'package:mxpertz_test/core/error/app_error.dart';

class SnackBarHelper {
  static void showError(BuildContext context, AppError appError) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(appError.message),
          backgroundColor: _getErrorColor(context, appError.type),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static Color _getErrorColor(BuildContext context, ErrorType type) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (type) {
      case ErrorType.network:
      case ErrorType.timeout:
        return Colors.orange;
      case ErrorType.authentication:
      case ErrorType.authorization:
        return Colors.red;
      case ErrorType.validation:
        return Colors.amber;
      case ErrorType.server:
        return Colors.deepOrange;
      default:
        return colorScheme.error;
    }
  }
}
