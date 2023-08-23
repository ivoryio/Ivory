import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final bool checked;

  final Function? onTap;

  const RadioButton({
    super.key,
    this.checked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: checked ? Colors.black : null,
          border: Border.all(
            color: const Color(0xFFEAECF0),
          ),
        ),
        child: Icon(
          checked ? Icons.check : Icons.radio_button_unchecked,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }
}
