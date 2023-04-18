import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/utilities/validator.dart';

import 'platform_text_input.dart';

const double _defaultFontSize = 28;
const TextAlign _defaultTextAlign = TextAlign.center;

String getCurrencySymbol(String currency) {
  switch (currency) {
    case 'EUR':
      return '€';
    case 'USD':
      return '\$';
    case 'GBP':
      return '£';
    default:
      return '';
  }
}

class PlatformCurrencyInput extends PlatformTextInput {
  final String currency;

  PlatformCurrencyInput({
    required this.currency,
    super.key,
    super.controller,
    super.onChanged,
    super.icon,
    super.textLabel,
    super.textLabelStyle,
    super.padding,
    super.borderRadius,
    required super.validator,
    super.disableBorderRadius = true,
    super.fontSize = _defaultFontSize,
    super.textAlign = _defaultTextAlign,
    super.border = const Border(
      bottom: BorderSide(color: Color(0xffD9D9D9), width: 1),
    ),
  }) : super(
          keyboardType: TextInputType.number,
          inputFormatters: [
            CurrencyTextInputFormatter(
              symbol: getCurrencySymbol(currency),
              decimalDigits: 2,
            ),
          ],
          hintText: CurrencyTextInputFormatter(
            symbol: getCurrencySymbol(currency),
            decimalDigits: 2,
          ).format('0'),
        );
}
