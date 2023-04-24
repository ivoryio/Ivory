class Validator {
  static isValidEmailAddress(String email) {
    return RegexValidator.emailAddress.hasMatch(email);
  }

  static isValidIban(String iban) {
    String valueWithoutSpaces = iban.replaceAll(" ", "");
    return RegexValidator.iban.hasMatch(valueWithoutSpaces);
  }
}

class RegexValidator {
  static RegExp digitsWithTwoDecimals = RegExp(r'^\d+\.?\d{0,2}');
  static RegExp emailAddress = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  /// [A-Z]{2} matches any two uppercase letters.
  ///
  /// \d{2} matches any two digits.
  ///
  /// [A-Z0-9]{4} matches any four characters that are either uppercase letters or digits.
  ///
  /// \d{8,21} matches any sequence of 8 to 21 digits.
  static RegExp iban = RegExp(r"^[A-Z]{2}\d{2}[A-Z0-9]{4}\d{8,21}");
}
