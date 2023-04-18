import 'package:flutter/material.dart';

import '../utilities/currency_text_field_controller.dart';
import 'platform_text_input.dart';

const double _defaultFontSize = 28;
const TextAlign _defaultTextAlign = TextAlign.center;

class PlatformCurrencyInput extends PlatformTextInput {
  @override
  // ignore: overridden_fields
  final CurrencyTextFieldController controller;

  PlatformCurrencyInput({
    super.key,
    super.icon,
    super.padding,
    super.onChanged,
    super.textLabel,
    super.borderRadius,
    super.textLabelStyle,
    required this.controller,
    required super.validator,
    super.disableBorderRadius = true,
    super.fontSize = _defaultFontSize,
    super.textAlign = _defaultTextAlign,
    super.border = const Border(
      bottom: BorderSide(color: Color(0xffD9D9D9), width: 1),
    ),
  }) : super(
          inputFormatters: [],
          keyboardType: TextInputType.number,
          hintText: '${controller.currencySymbol} 0.00',
        );
}
