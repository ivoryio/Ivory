import 'package:flutter/material.dart';

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
        width: 20,
        height: 20,
        child: Checkbox(
          activeColor: Theme.of(context).primaryColor,
          side: const BorderSide(
            color: Color(0xFFCFD9E0),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
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
