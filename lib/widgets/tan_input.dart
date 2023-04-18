import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class InputCodeBox extends StatelessWidget {
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final Function(String value)? onChanged;

  const InputCodeBox({
    super.key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: const Color(0xffC4C4C4),
        ),
      ),
      child: PlatformTextFormField(
        focusNode: focusNode,
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }
}

class TanInput extends StatelessWidget {
  final int length;
  final Function(String tan) onCompleted;

  const TanInput({
    super.key,
    required this.length,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    List<TextEditingController> controllers =
        List.from([for (var i = 0; i < length; i++) TextEditingController()]);

    List<FocusNode> focusNodes =
        List.from([for (var i = 0; i < length; i++) FocusNode()]);

    void onChange(int inputIndex) {
      String tan = controllers.map((controller) => controller.text).join("");

      if (controllers[inputIndex].text.isEmpty) {
        return;
      }

      for (var i = 0; i < controllers.length - 1; i++) {
        if (controllers[i].text.isNotEmpty) {
          int nextIndex =
              controllers.indexWhere((controller) => controller.text.isEmpty);
          if (nextIndex != -1) {
            FocusScope.of(context).unfocus(
                disposition: UnfocusDisposition.previouslyFocusedChild);
            FocusScope.of(context).requestFocus(focusNodes[nextIndex]);
          }
        }
      }

      if (tan.length == length) {
        onCompleted(tan);
      }
    }

    return Form(
      key: formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var inputIndex = 0; inputIndex < length; inputIndex++)
            InputCodeBox(
              controller: controllers[inputIndex],
              focusNode: focusNodes[inputIndex],
              onChanged: (value) => onChange(inputIndex),
            )
        ],
      ),
    );
  }
}
