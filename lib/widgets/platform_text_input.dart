import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformTextInput extends StatefulWidget {
  final String textLabel;
  final TextStyle? textLabelStyle;
  final String? hintText;
  final bool? obscureText;
  final Function validator;
  final Function? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final IconData? icon;

  const PlatformTextInput({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType,
    required this.textLabel,
    required this.validator,
    this.textLabelStyle,
    this.obscureText = false,
    this.icon,
  });

  @override
  State<PlatformTextInput> createState() => _PlatformTextInputState();
}

class _PlatformTextInputState extends State<PlatformTextInput> {
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.textLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(widget.textLabel,
                style: const TextStyle(
                  color: Color(0xFF414D63),
                  fontSize: 16,
                ).merge(widget.textLabelStyle)),
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
              if (widget.icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    widget.icon,
                    color: const Color(0xFF667085),
                    size: 20.0,
                  ),
                ),
              Expanded(
                child: PlatformTextFormField(
                  controller: widget.controller,
                  validator: (value) {
                    return widget.validator(value);
                  },
                  hintText: widget.hintText ?? "",
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  inputFormatters: [
                    if (widget.keyboardType == TextInputType.phone)
                      FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) =>
                      {if (widget.onChanged != null) widget.onChanged!(value)},
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
