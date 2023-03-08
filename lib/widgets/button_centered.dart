import 'package:flutter/material.dart';

class ButtonCentered extends StatelessWidget {
  final VoidCallback action;
  final String label;

  const ButtonCentered({super.key, required this.action, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: action,
        child: Text(label),
      ),
    );
  }
}
