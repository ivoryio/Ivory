import 'package:intl/intl.dart';

class Format {
  static String currency(
    num number, {
    int digits = 2,
    String symbol = " € ",
    String locale = "en_US",
  }) {
    NumberFormat formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: digits,
    );

    if (number % 1 != 0 && digits == 0) {
      return formatter
          .format(number.isNegative ? number.ceil() : number.floor());
    }

    return formatter.format(number);
  }

  static String euro(
    num value, {
    int digits = 0,
    int maxDigits = 2,
  }) {
    if (digits == 0 && maxDigits > 0 && value % 1 != 0) {
      return Format.currency(value, digits: maxDigits);
    }

    return Format.currency(value, digits: digits);
  }

  static String cents(num value) {
    return (value.toDouble() % 1).toStringAsFixed(2).substring(2);
  }

  static String iban(String iban) {
    String formattedIban = "";
    String ibanWithoutSpaces = iban.replaceAll(" ", "");

    for (int i = 0; i < ibanWithoutSpaces.length; i++) {
      formattedIban += ibanWithoutSpaces[i];
      if ((i + 1) % 4 == 0 && i != ibanWithoutSpaces.length - 1) {
        formattedIban += " ";
      }
    }
    return formattedIban;
  }

  static String getCurrenySymbol(String currency) {
    switch (currency) {
      case "EUR":
        return "€";
      case "USD":
        return "\$";
      case "GBP":
        return "£";
      default:
        throw Exception("currency not supported: $currency");
    }
  }
}
