import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:solarisdemo/models/amount_value.dart';

class Format {
  static String currency(
    num number, {
    int digits = 2,
    String symbol = "€ ",
  }) {
    NumberFormat formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: digits,
    );

    if (number % 1 != 0 && digits == 0) {
      return formatter.format(number.isNegative ? number.ceil() : number.floor());
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

  static String amountWithSign(AmountValue amount) {
    double value = amount.value;
    String currencySymbol = getCurrencySymbol(amount.currency);

    String formattedAmount = value.abs().toStringAsFixed(2);
    String sign = value < 0 ? '-' : '+';

    return '$sign $currencySymbol$formattedAmount';
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

  static String getCurrencySymbol(String currency) {
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

  static String date(DateTime date, {String? pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(date);
  }
}

class InputFormatter {
  static MaskTextInputFormatter iban = MaskTextInputFormatter(
    mask: "AA00 BBBB 0000 0000 0000 00",
    filter: {
      "A": RegExp(r"[A-Za-z]"),
      "B": RegExp(r"[A-Za-z0-9]"),
      "0": RegExp(r"[0-9]"),
    },
  );
}
