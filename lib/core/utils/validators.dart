import 'package:mxpertz_test/core/constants/app_strings.dart';

class Validators {
  static String? textFieldValidator(
    String? value, {
    String errorMessage = AppStrings.invalidInput,
  }) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter phone number';
    }
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  static String? emailValidator(
    String? value, {
    String errorMessage = AppStrings.invalidInput,
  }) {
    if (value == null ||
        !RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
        ).hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}
