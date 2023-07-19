class Validator {
  static isValidEmailAddress(String email) {
    return RegexValidator.emailAddress.hasMatch(email);
  }

  static isValidPasscode(String passcode) {
    return passcode.length >= 6;
  }

  static isValidIban(String iban) {
    String valueWithoutSpaces = iban.replaceAll(" ", "");
    return RegexValidator.iban.hasMatch(valueWithoutSpaces);
  }

  //Todo: Add phone number validation
  // static isValidPhoneNumber(String phoneNumber) {
  //   String valueWithoutSpaces = phoneNumber.replaceAll(" ", "");
  //   return RegexValidator.phoneNumber.hasMatch(valueWithoutSpaces);
  // }
}

class PinValidator {
  static bool checkIfPinDiffersFromString(String string, String pin) {
    return pin != string;
  }

  static bool checkIfPinDiffersFromBirthDate(String birthDate, String pin) {
    return pin != birthDate;
  }

  static bool checkIfPinIsNotSequence(String pin) {
    for (int i = 0; i < pin.length - 1; i++) {
      int currentDigit = int.parse(pin[i]);
      int nextDigit = int.parse(pin[i + 1]);

      if (currentDigit != nextDigit - 1) {
        return true;
      }
    }
    return false;
  }

  static bool checkPinHasNoDigitsRepeating(String pin) {
    var uniqueDigits = pin.split('').toSet();
    return uniqueDigits.length >= 2;
  }
}

class RegexValidator {
  static RegExp digitsWithTwoDecimals = RegExp(r'^\d+\.?\d{0,2}');
  static RegExp emailAddress = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  //Todo: Add phone number validation
  // ^\+    : start with a "+"
  // \d+    : one or more digits
  // static RegExp phoneNumber = RegExp(r'^\+\d+$');

  /// [A-Z]{2} matches any two uppercase letters.
  ///
  /// \d{2} matches any two digits.
  ///
  /// [A-Z0-9]{4} matches any four characters that are either uppercase letters or digits.
  ///
  /// \d{8,21} matches any sequence of 8 to 21 digits.
  static RegExp iban = RegExp(r"^[A-Z]{2}\d{2}[A-Z0-9]{4}\d{14}");
}
