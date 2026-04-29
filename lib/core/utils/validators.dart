import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class AppValidators {
  static String? requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredFieldError;
    }
    return null;
  }

  static String? userIdOrEmail(String? value) {
    final cleaned = value?.trim() ?? '';
    if (cleaned.isEmpty) {
      return AppStrings.requiredFieldError;
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    final isUserId = cleaned.length >= 3 && !cleaned.contains(' ');
    if (emailPattern.hasMatch(cleaned) || isUserId) {
      return null;
    }
    return AppStrings.invalidEmailOrIdError;
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return AppStrings.invalidPasswordError;
    }
    return null;
  }

  static String? mobile(String? value) {
    final digitsOnly = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digitsOnly.length != 10) {
      return AppStrings.mobileValidationError;
    }
    return null;
  }

  static String? otp(String? value) {
    final digitsOnly = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digitsOnly.length != AppConstants.otpLength) {
      return AppStrings.otpValidationError;
    }
    return null;
  }
}
