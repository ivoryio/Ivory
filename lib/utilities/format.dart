import 'package:intl/intl.dart';

class Format {
  static String euro(num number, {int digits = 2}) {
    NumberFormat formatter = NumberFormat.currency(
      locale: "en_US",
      symbol: " € ",
      decimalDigits: digits,
    );
    if (number % 1 != 0 && digits == 0) {
      return formatter
          .format(number.isNegative ? number.ceil() : number.floor());
    }

    return formatter.format(number);
  }

  static String euroFromCents(
    num cents, {
    int digits = 0,
    int maxDigits = 2,
  }) {
    num value = cents / 100;
    if (digits == 0 && maxDigits > 0 && value % 1 != 0) {
      return euro(value, digits: maxDigits);
    }

    return euro(value, digits: digits);
  }

  static String cents(num value) {
    return (value.toDouble() % 1).toStringAsFixed(2).substring(2);
  }

  static String iban(String iban) {
    String formattedIban = "";

    for (int i = 0; i < iban.length; i++) {
      formattedIban += iban[i];
      if ((i + 1) % 4 == 0 && i != iban.length - 1) {
        formattedIban += " ";
      }
    }
    return formattedIban;
  }
}
