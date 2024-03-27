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

    if (digits == 0 && number.toInt() == 0 && number < 0) {
      return "-${formatter.format(number.abs())}";
    }

    if (digits == 0 && number > 0) {
      return formatter.format(number.toInt());
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
    String valueString = value.toString();

    if (valueString.contains('.')) {
      List<String> parts = valueString.split('.');
      if (parts.length == 2) {
        String fractionalPart = parts[1];
        if (fractionalPart.length >= 2) {
          return fractionalPart.substring(0, 2);
        } else {
          return fractionalPart.padRight(2, '0');
        }
      }
    }

    return '0';
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
      case 'RON':
        return "RON";  
      default:
        throw Exception("currency not supported: $currency");
    }
  }

  static String date(DateTime date, {String? pattern = "yyyy-MM-dd"}) {
    return DateFormat(pattern).format(date);
  }

  static DateTime? tryParseDate(String date, {String? pattern = "yyyy-MM-dd"}) {
    try {
      return DateFormat(pattern).parseStrict(date);
    } catch (_) {
      return null;
    }
  }

  static String fileSize(int value) {
    const int kb = 1024;
    const int mb = 1024 * kb;

    if (value < kb) {
      return '$value B';
    } else if (value < mb) {
      double sizeInKB = value / kb;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else {
      double sizeInMB = value / mb;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    }
  }

  static String fileType(String fileType) {
    final Map<String, String> fileTypes = {
      'application/pdf': 'PDF',
      'image/jpeg': 'JPEG',
      'image/png': 'PNG',
    };

    return fileTypes[fileType] ?? fileType;
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

  static MaskTextInputFormatter taxId(String initialText) => MaskTextInputFormatter(
        initialText: initialText,
        mask: "000 000 000 000 000 000",
        filter: {
          "0": RegExp(r"[0-9]"),
        },
      );

  static MaskTextInputFormatter createPhoneNumberFormatter(String phoneNumberFormat) {
    return MaskTextInputFormatter(
      type: MaskAutoCompletionType.eager,
      mask: phoneNumberFormat,
      filter: {
        "#": RegExp(r"[0-9]"),
      },
    );
  }

  static MaskTextInputFormatter date({String? initialText}) => MaskTextInputFormatter(
        mask: "##/##/####",
        initialText: initialText,
        type: MaskAutoCompletionType.eager,
        filter: {
          "#": RegExp(r"[0-9]"),
        },
      );

  static MaskTextInputFormatter cardNumber(String initialText) => MaskTextInputFormatter(
      initialText: initialText,
      mask: "0000 0000 0000 0000",
      filter: {
        "0": RegExp(r"[0-9]"),
      },
  );
}
