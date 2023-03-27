import 'package:intl/intl.dart';

class Format {
  static String euro(num number, {int digits = 2}) {
    return NumberFormat.currency(
      locale: "en_US",
      symbol: "€ ",
      decimalDigits: digits,
    ).format(number);
  }

  static String euroFromCents(num cents) {
    return euro(cents / 100, digits: 0);
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
