import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PinField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode; // Added

  const PinField({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.focusNode,
  }) // Added
  : super(key: key);

  @override
  PinFieldState createState() => PinFieldState();
}

class PinFieldState extends State<PinField> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChanged);
  }

  void _handleTextChanged() {
    setState(() {
      log('Text changed: ${widget.controller.text}');
      _hasText = widget.controller.text.isNotEmpty;
      log('Has text: $_hasText');
    });
    widget.onChanged(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 10,
          height: 10,
          child: PlatformTextField(
            focusNode: widget.focusNode, // Added
            controller: widget.controller,
            maxLength: 1,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              fontSize: 12,
            ),
            material: (_, __) => MaterialTextFieldData(
              decoration: InputDecoration(
                fillColor: _hasText ? Colors.green : Colors.grey,
                filled: true,
              ),
            ),
            cupertino: (_, __) => CupertinoTextFieldData(
              decoration: BoxDecoration(
                color: CupertinoDynamicColor.withBrightness(
                  color: _hasText // YOUR COLOR
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemGrey,
                  darkColor: _hasText // YOUR COLOR
                      ? CupertinoColors.systemGreen
                      : CupertinoColors.systemGrey,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    super.dispose();
  }
}
