
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../config.dart';

class InputCodeBox extends StatefulWidget {
  final bool? obscureText;
  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String value)? onChanged;
  final bool isFocused;

  const InputCodeBox({
    Key? key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.obscureText = false,
    this.onChanged,
    required this.isFocused,
  }) : super(key: key);

  @override
  _InputCodeBoxState createState() => _InputCodeBoxState();
}

class _InputCodeBoxState extends State<InputCodeBox> {
  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isFocused ? ClientConfig.getColorScheme().primary : const Color(0xFFCFD4D9);

    return Container(
      padding: const EdgeInsets.only(left: 4),
      width: 48,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: borderColor,
        ),
        color: const Color(0xFFF8F9FA),
      ),
      child: Center(
        child: TextFormField(
          focusNode: widget.focusNode,
          controller: widget.controller,
          textAlign: TextAlign.center,
          obscureText: widget.obscureText!,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            hintText: widget.hintText ?? '',
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFFADADB4),
            ),
          ),
        ),
      ),
    );
  }
}

class TanInput extends StatefulWidget {
  final int length;
  final Function(String tan) onCompleted;
  final Function(bool)? updateInputComplete;
  final String? hintText;
  final TextEditingController? controller;

  const TanInput({
    Key? key,
    required this.length,
    required this.onCompleted,
    this.hintText,
    this.controller,
    this.updateInputComplete,
  }) : super(key: key);

  @override
  TanInputState createState() => TanInputState();
}

class TanInputState extends State<TanInput> {
  late GlobalKey<FormState> formKey;

  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  bool anyInputFocused = false;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();

    controllers = List.from(
      [for (var i = 0; i < widget.length; i++) TextEditingController()],
    );

    focusNodes = List.from(
      [for (var i = 0; i < widget.length; i++) FocusNode()],
    );

    for (var focusNode in focusNodes) {
      focusNode.addListener(_updateFocusStatus);
    }

    if (widget.controller != null) {
      for (var i = 0; i < widget.length; i++) {
        controllers[i].text = widget.controller!.text.length > i ? widget.controller!.text[i] : '';
        controllers[i].addListener(() {
          widget.controller!.text = controllers.map((controller) => controller.text).join();
        });
      }
    }
  }

  void _updateFocusStatus() {
    setState(() {
      anyInputFocused = focusNodes.any((node) => node.hasFocus);
    });
  }

  void onChange(int inputIndex) {
    String tan = controllers.map((controller) => controller.text).join("");

    if (widget.updateInputComplete != null) {
      if (tan.length < widget.length) {
        widget.updateInputComplete!(false);
      }
    }

    if (controllers[inputIndex].text.isEmpty) {
      return;
    }

    for (var i = 0; i < controllers.length - 1; i++) {
      if (controllers[i].text.isNotEmpty) {
        int nextIndex = controllers.indexWhere((controller) => controller.text.isEmpty);
        if (nextIndex != -1) {
          FocusScope.of(context).unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
          FocusScope.of(context).requestFocus(focusNodes[nextIndex]);
        }
      }
    }

    if (tan.length == widget.length) {
      widget.onCompleted(tan);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var inputIndex = 0; inputIndex < widget.length; inputIndex++)
            InputCodeBox(
              controller: controllers[inputIndex],
              focusNode: focusNodes[inputIndex],
              onChanged: (value) => onChange(inputIndex),
              hintText: widget.hintText,
              isFocused: anyInputFocused,
            ),
        ],
      ),
    );
  }
}
