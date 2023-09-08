import 'package:flutter/material.dart';

import '../config.dart';

class CheckboxWidget extends StatefulWidget {
  final bool isChecked;
  final Function(bool) onChanged;

  const CheckboxWidget(
      {super.key, required this.isChecked, required this.onChanged});

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
          activeColor: ClientConfig.getColorScheme().secondary,
          side: MaterialStateBorderSide.resolveWith(
                  (states) {
                    if(states.contains((MaterialState.selected))) {
                      return BorderSide(width: 1.0, color: ClientConfig.getColorScheme().secondary);
                    }
                    return const BorderSide(width: 1.0, color: Color.fromRGBO(110, 117, 124, 1));
                  }),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          value: _isChecked,
          onChanged: (checked) {
            setState(() {
              _isChecked = checked!;
              widget.onChanged(checked);
            });
          },
        ),
      ),
    );
  }
}
