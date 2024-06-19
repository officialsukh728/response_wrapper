import 'package:sample/utils/common/print_log.dart';

/// Class containing various validator methods for form input fields.
class AppValidators {
  /// Validates the email input.
  /// If [useReg] is true, it uses regular expression for validation, else basic string checking.
  static String? validateEmail(String? value, {bool useReg = true}) {
    if (value == null || value.isEmpty) {
      return 'Please enter email';
    }
    if (useReg) {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegExp.hasMatch(value)) {
        return 'Please enter a valid email';
      }
    }

    return null;
  }

  /// Validates the number input.
  /// [length] specifies the maximum length of the number.
  /// [maxLength] specifies the maximum value of the number.
  static String? validateNumber(String? value, {int length = 2, int maxLength = 100}) {
    if (value == null || value.isEmpty) {
      return 'Please enter number';
    }

    if (value.length > length || num.tryParse(value) == null || (num.tryParse(value) ?? 0) > maxLength) {
      return 'Please enter a valid $length-digit number';
    }

    return null;
  }

  /// Validates the password input.
  /// [length] specifies the minimum length of the password.
  static String? validatePassword(String? value, {int length = 8}) {
    if (value == null || value.isEmpty) {
      return 'Please enter password';
    }
    if (value.length <= length - 1) {
      return 'Password must be at least $length characters long';
    }

    return null;
  }

  /// Validates the input to be a number between 1 and 100.
  static String? validateOptionalNumber1To100(String? value, {int length = 8}) {
    if (value != null && value.isNotEmpty) {
      final number = num.tryParse(value) ?? 0;
      if (number >= 1 && number <= 100) {
        return null; // Valid input
      } else {
        return 'Please enter a number between 1 and 100';
      }
    }
    return null;
  }

  /// Validates the input for a new password.
  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 7) {
      return 'Password must be at least 8 characters long';
    }

    return null;
  }

  /// Validates the name input.
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    return null;
  }
  static String? startTimeValidate({required String? value, required String end}) {
    if (value == null || value.isEmpty) {
      return 'Please select a start time';
    }
    try {
      if (end.isNotEmpty) {
        DateTime startTime = convertTimeStringToDateTime(value);
        DateTime endTime = convertTimeStringToDateTime(end);
        if (startTime.isAfter(endTime)) {
          return 'Start time cannot be after end time';
        } else if (startTime == endTime) {
          return 'Start time cannot be equal to end time';
        }
      }
    } catch (e) {
      errorLog(e);
      return 'An error occurred';
    }
    return null;
  }

  static String? endTimeValidate({required String? value, required String start}) {
    if (value == null || value.isEmpty) {
      return 'Please select an end time';
    }
    try {
      if (start.isNotEmpty) {
        DateTime startTime = convertTimeStringToDateTime(start);
        DateTime endTime = convertTimeStringToDateTime(value);
        if (endTime.isBefore(startTime)) {
          return 'End time cannot be before start time';
        } else if (endTime == startTime) {
          return 'End time cannot be equal to start time';
        }
      }
    } catch (e) {
      errorLog(e);
      return 'An error occurred';
    }
    return null;
  }

  static DateTime convertTimeStringToDateTime(String timeString, {String arbitraryDate = "2022-01-01"}) {
    try {
      String dateTimeString = "$arbitraryDate $timeString";
      DateTime dateTime = DateTime.parse(dateTimeString);
      return dateTime;
    } catch (e) {
      errorLog(e);
      return DateTime.now();
    }
  }

  /// Validates the job title input.
  static String? validateJobTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter job title';
    }
    return null;
  }

  /// Validates the input for a message.
  static String? validateMessage1(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter something about you';
    }
    return null;
  }

  /// Validates the input for a message.
  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter';
    }
    return null;
  }

  /// Validates the input for a custom message.
  static String? validateCustom(String? v, {required String message}) {
    if (v == null || v.isEmpty) {
      return 'Please enter $message';
    }
    return null;
  }

  /// Validates the input for a URL.
  static String? validateURL(String? v, {required String message}) {
    if (v == null || v.isEmpty) {
      return 'Please enter $message';
    }
    // if (!Uri.parse(v).isAbsolute) {
    //   return 'Please enter a valid URL for $message';
    // }
    return null;
  }

  /// Validates the gender input.
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your gender';
    }
    return null;
  }

  /// Validates the input for a mobile number with country code.
  static String? validateMobileNumberWithCountryCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }

    return null;
  }

  /// Validates the input for a birthday.
  static String? validateBirthday(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Date of Birth';
    }
    return null;
  }

  /// Validates the confirm password input.
  static String? validateConfirmPassword(String? value, String? matchValue) {
    if (value == null || value.isEmpty) {
      return 'Please enter confirm password';
    } else if (value != matchValue) {
      return 'Password not match';
    } else {
      return null;
    }
  }

  /// Validates the OTP input.
  static String? validateOTPOnFront(String? value, String? matchValue) {
    if (value == null || value.isEmpty) {
      return 'Please enter otp';
    } else if (value != matchValue) {
      return 'Otp not match';
    } else {
      return null;
    }
  }

  /// Validates the OTP input.
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter otp';
    } else {
      return null;
    }
  }
}
