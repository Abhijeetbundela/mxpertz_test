import 'package:firebase_auth/firebase_auth.dart';
import 'package:mxpertz_test/core/enums/error_type.dart';

import 'app_error.dart';

class ErrorHandler {
  factory ErrorHandler() => _instance;

  const ErrorHandler._internal();

  static const ErrorHandler _instance = ErrorHandler._internal();

  AppError handleError(dynamic error, [StackTrace? stackTrace]) {
    AppError appError;

    if (error is AppError) {
      appError = error;
    } else if (error is FirebaseAuthException) {
      return _handleFirebaseAuthError(error);
    } else if (error is FirebaseException) {
      return _handleFirebaseError(error);
    } else if (error is FormatException) {
      return AppError(
        message: 'Invalid data format',
        type: ErrorType.validation,
        originalError: error,
      );
    } else {
      appError = AppError(
        message: error.toString().isNotEmpty
            ? error.toString()
            : 'An unexpected error occurred. Please try again.',
        type: ErrorType.unknown,
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    return appError;
  }

  AppError _handleFirebaseAuthError(FirebaseAuthException error) {
    String message = 'Authentication error occurred';
    ErrorType type = ErrorType.authentication;

    switch (error.code) {
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'wrong-password':
        message = 'Incorrect password.';
        break;
      case 'user-disabled':
        message = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many failed attempts. Please try again later.';
        type = ErrorType.rateLimit;
        break;
      case 'operation-not-allowed':
        message = 'This operation is not allowed.';
        type = ErrorType.authorization;
        break;
      case 'invalid-email':
        message = 'Invalid email address.';
        type = ErrorType.validation;
        break;
      case 'weak-password':
        message = 'Password is too weak.';
        type = ErrorType.validation;
        break;
      case 'email-already-in-use':
        message = 'An account with this email already exists.';
        type = ErrorType.validation;
        break;
      case 'invalid-verification-code':
        message = 'Invalid verification code.';
        type = ErrorType.validation;
        break;
      case 'invalid-verification-id':
        message = 'Invalid verification ID.';
        type = ErrorType.validation;
        break;
      case 'network-request-failed':
        message = 'Network error. Please check your connection.';
        type = ErrorType.network;
        break;
      default:
        message = error.message ?? 'Authentication error occurred';
    }

    return AppError(
      message: message,
      type: type,
      originalError: error,
      code: error.code,
    );
  }

  AppError _handleFirebaseError(FirebaseException error) {
    String message = 'Firebase error occurred';
    ErrorType type = ErrorType.server;

    switch (error.code) {
      case 'permission-denied':
        message = 'You don\'t have permission to perform this action.';
        type = ErrorType.authorization;
        break;
      case 'not-found':
        message = 'The requested document was not found.';
        type = ErrorType.notFound;
        break;
      case 'already-exists':
        message = 'The document already exists.';
        type = ErrorType.validation;
        break;
      case 'resource-exhausted':
        message = 'Resource limit exceeded. Please try again later.';
        type = ErrorType.rateLimit;
        break;
      case 'unauthenticated':
        message = 'You need to be logged in to perform this action.';
        type = ErrorType.authentication;
        break;
      case 'unavailable':
        message = 'Service is currently unavailable. Please try again later.';
        type = ErrorType.server;
        break;
      default:
        message = error.message ?? 'Firebase error occurred';
    }

    return AppError(
      message: message,
      type: type,
      originalError: error,
      code: error.code,
    );
  }
}
