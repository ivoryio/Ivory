import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformTextInput extends StatefulWidget {
  final TextEditingController controller;

  const PlatformTextInput({super.key, required this.controller});

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
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Label",
              style: TextStyle(color: Color(0xFF414D63), fontSize: 18)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFAEC1CC), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PlatformTextFormField(
            controller: widget.controller,
            validator: (value) {
              return null;
            },
            cupertino: (context, platform) => CupertinoTextFormFieldData(
              placeholder: 'Phone number',
              placeholderStyle: const TextStyle(
                color: Color(0xFF414D63),
                fontSize: 18,
              ),
              padding: const EdgeInsets.all(0),
            ),
          ),
        ),
      ],
    );
  }
}
