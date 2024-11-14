import 'package:flutter/material.dart';

import '../config.dart';

class CheckboxWidget extends StatefulWidget {
  final double size;
  final bool isChecked;
  final bool isDisabled;
  final Null Function(bool)? onChanged;

  const CheckboxWidget({
    super.key,
    this.size = 24,
    required this.isChecked,
    required this.onChanged,
    this.isDisabled = false,
  });

  @override
  State<StatefulWidget> createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const checkboxSize = 20;
    final scale = 1 + (1 - checkboxSize / widget.size);

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Transform.scale(
          scale: scale,
          child: Checkbox(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
            ),
            fillColor: WidgetStateColor.resolveWith((states) {
              if (states.contains((WidgetState.selected))) {
                if (states.contains((WidgetState.disabled))) {
                  return ClientConfig.getCustomColors().neutral500;
                }
                return ClientConfig.getColorScheme().secondary;
              } else {
                return ClientConfig.getColorScheme().surface;
              }
            }),
            checkColor: Colors.white,
            side: WidgetStateBorderSide.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500);
              }

              if (states.contains((WidgetState.selected))) {
                return BorderSide(width: 1, color: ClientConfig.getColorScheme().secondary);
              }

              return BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral600);
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            value: _isChecked,
            onChanged: widget.isDisabled
                ? null
                : (checked) {
                    setState(() {
                      _isChecked = checked!;
                    });
                    widget.onChanged?.call(checked!);
                  },
          ),
        ),
      ),
    );
  }
}
