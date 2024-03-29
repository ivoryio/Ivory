import 'package:flutter/material.dart';

import '../config.dart';

class CheckboxWidget extends StatefulWidget {
  final bool isChecked;

  final bool isDisabled;
  final Null Function(bool)? onChanged;

  const CheckboxWidget({
    super.key,
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
    return Material(
      child: SizedBox(
        width: 24,
        height: 24,
        child: Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
          ),
          fillColor: MaterialStateColor.resolveWith((states) {
            if (states.contains((MaterialState.selected))) {
              if (states.contains((MaterialState.disabled))) {
                return ClientConfig.getCustomColors().neutral500;
              }
              return ClientConfig.getColorScheme().secondary;
            } else {
              return ClientConfig.getColorScheme().surface;
            }
          }),
          activeColor: ClientConfig.getColorScheme().secondary,
          side: MaterialStateBorderSide.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return BorderSide(width: 1, color: ClientConfig.getCustomColors().neutral500);
            }

            if (states.contains((MaterialState.selected))) {
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
    );
  }
}
