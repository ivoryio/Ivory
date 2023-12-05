import 'package:flutter/material.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart' as tan_input;
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:solarisdemo/config.dart';

class TanInput extends StatefulWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? isLoading;
  final Function(String tan) onChanged;

  const TanInput({
    super.key,
    required this.length,
    required this.onChanged,
    this.controller,
    this.focusNode,
    this.isLoading,
  });

  @override
  State<TanInput> createState() => TanInputState();
}

class TanInputState extends State<TanInput> {
  @override
  void initState() {
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 64,
              child: tan_input.PinInputTextField(
                pinLength: widget.length,
                decoration: tan_input.BoxLooseDecoration(
                  gapSpace: 8,
                  radius: const Radius.circular(4),
                  strokeColorBuilder: FixedColorBuilder(
                    widget.focusNode != null && widget.focusNode!.hasFocus
                        ? ClientConfig.getColorScheme().primary
                        : ClientConfig.getCustomColors().neutral300,
                  ),
                  bgColorBuilder: FixedColorBuilder(
                    ClientConfig.getCustomColors().neutral100,
                  ),
                  hintText: List.filled(widget.length, '#').join(),
                  textStyle: widget.isLoading != null && widget.isLoading!
                      ? ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                            color: ClientConfig.getCustomColors().neutral500,
                          )
                      : ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                            color: ClientConfig.getCustomColors().neutral900,
                          ),
                  hintTextStyle: ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                        color: ClientConfig.getCustomColors().neutral500,
                      ),
                ),
                controller: widget.controller,
                focusNode: widget.focusNode,
                enabled: widget.isLoading != null && !widget.isLoading!,
                keyboardType: TextInputType.number,
                onSubmit: (pin) {
                  debugPrint('submit pin:$pin');
                },
                onChanged: (pin) => widget.onChanged(pin),
                cursor: tan_input.Cursor(
                  height: 16,
                  width: 1,
                  offset: 0,
                  color: ClientConfig.getCustomColors().neutral900,
                  radius: const Radius.circular(1),
                  enabled: widget.focusNode != null && widget.focusNode!.hasFocus,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
