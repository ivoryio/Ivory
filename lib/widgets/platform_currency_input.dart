import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/platform_text_input.dart';

const double _defaultFontSize = 28;
const String _defaultHintText = '0.00';
const TextAlign _defaultTextAlign = TextAlign.center;

class PlatformCurrencyInput extends PlatformTextInput {
  const PlatformCurrencyInput({
    super.key,
    super.controller,
    super.onChanged,
    super.icon,
    super.textLabel,
    super.textLabelStyle,
    super.padding,
    super.keyboardType,
    super.borderRadius,
    required super.validator,
    super.disableBorderRadius = true,
    super.hintText = _defaultHintText,
    super.fontSize = _defaultFontSize,
    super.textAlign = _defaultTextAlign,
    super.border = const Border(
      bottom: BorderSide(color: Color(0xffD9D9D9), width: 1),
    ),
  });
}
