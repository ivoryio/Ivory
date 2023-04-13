import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../utilities/validator.dart';

const String _defaultHintText = '';
const double _defaultFontSize = 16;
const bool _defaultObscureText = false;
const bool _defaultDisableBorderRadius = false;
const TextAlign _defaultTextAlign = TextAlign.start;
BorderRadius _defaultBorderRadius = BorderRadius.circular(8);
Border _defaultBorder = Border.all(color: const Color(0xFFAEC1CC), width: 1);
const EdgeInsets _defaultPadding = EdgeInsets.symmetric(
  vertical: 5,
  horizontal: 14,
);

class PlatformTextInput extends StatelessWidget {
  final IconData? icon;
  final Border? border;
  final String? hintText;
  final double? fontSize;
  final String? textLabel;
  final bool? obscureText;
  final Function validator;
  final EdgeInsets? padding;
  final TextAlign? textAlign;
  final TextStyle? textLabelStyle;
  final bool? disableBorderRadius;
  final BorderRadius? borderRadius;
  final TextInputType? keyboardType;
  final Function(String value)? onChanged;
  final TextEditingController? controller;

  const PlatformTextInput({
    super.key,
    this.icon,
    this.border,
    this.textLabel,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.borderRadius,
    this.textLabelStyle,
    required this.validator,
    this.padding = _defaultPadding,
    this.hintText = _defaultHintText,
    this.fontSize = _defaultFontSize,
    this.textAlign = _defaultTextAlign,
    this.obscureText = _defaultObscureText,
    this.disableBorderRadius = _defaultDisableBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              textLabel!,
              style: const TextStyle(
                color: Color(0xFF414D63),
                fontSize: 16,
              ).merge(textLabelStyle),
            ),
          ),
        Container(
          padding: padding,
          decoration: BoxDecoration(
            border: border ?? _defaultBorder,
            borderRadius: disableBorderRadius!
                ? null
                : borderRadius ?? _defaultBorderRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    icon,
                    color: const Color(0xFF667085),
                    size: 20.0,
                  ),
                ),
              Expanded(
                child: PlatformTextFormField(
                  textAlign: textAlign,
                  controller: controller,
                  hintText: hintText,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  inputFormatters: [
                    if (keyboardType == TextInputType.phone)
                      FilteringTextInputFormatter.digitsOnly,
                    if (keyboardType == TextInputType.number)
                      FilteringTextInputFormatter.allow(
                          RegexValidator.digitsWithTwoDecimals),
                  ],
                  onChanged: (value) => {
                    if (onChanged != null) onChanged!(value),
                  },
                  validator: (value) {
                    return validator(value);
                  },
                  style: TextStyle(
                    color: const Color(0xFF414D63),
                    fontSize: fontSize,
                    height: 1.5,
                  ),
                  material: (context, platform) => MaterialTextFormFieldData(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                  cupertino: (context, platform) => CupertinoTextFormFieldData(
                    style: TextStyle(
                      color: const Color(0xFF414D63),
                      fontSize: fontSize,
                      height: 1.2,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
