import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformTextInput extends StatefulWidget {
  final String textLabel;
  final String? hintText;
  final bool? obscureText;
  final Function validator;
  final Function? onChanged;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const PlatformTextInput({
    super.key,
    this.hintText,
    this.onChanged,
    this.controller,
    this.keyboardType,
    required this.textLabel,
    required this.validator,
    this.obscureText = false,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Text(
            widget.textLabel,
            style: const TextStyle(
              color: Color(0xFF414D63),
              fontSize: 16,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: defaultTargetPlatform == TargetPlatform.iOS ? 10 : 0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFAEC1CC), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
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
            material: (context, platform) => MaterialTextFormFieldData(
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(0),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Color(0xFF414D63),
                  fontSize: 16,
                ),
              ),
            ),
            cupertino: (context, platform) => CupertinoTextFormFieldData(
              style: const TextStyle(
                color: Color(0xFF414D63),
                fontSize: 16,
              ),
              placeholderStyle: const TextStyle(
                color: Color(0xFF414D63),
                fontSize: 16,
              ),
              padding: const EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }
}
