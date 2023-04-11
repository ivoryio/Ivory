import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformTextInput extends StatelessWidget {
  final IconData? icon;
  final String textLabel;
  final String? hintText;
  final bool? obscureText;
  final Function validator;
  final TextStyle? textLabelStyle;
  final TextInputType? keyboardType;
  final Function(String value)? onChanged;
  final TextEditingController? controller;

  const PlatformTextInput({
    super.key,
    this.icon,
    this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType,
    this.textLabelStyle,
    required this.textLabel,
    required this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (textLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              textLabel,
              style: const TextStyle(
                color: Color(0xFF414D63),
                fontSize: 16,
              ).merge(textLabelStyle),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFAEC1CC), width: 1),
            borderRadius: BorderRadius.circular(8),
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
                  controller: controller,
                  validator: (value) {
                    return validator(value);
                  },
                  hintText: hintText ?? "",
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  inputFormatters: [
                    if (keyboardType == TextInputType.phone)
                      FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) =>
                      {if (onChanged != null) onChanged!(value)},
                  style: const TextStyle(
                    color: Color(0xFF414D63),
                    fontSize: 16,
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
                    style: const TextStyle(
                      color: Color(0xFF414D63),
                      fontSize: 16,
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
