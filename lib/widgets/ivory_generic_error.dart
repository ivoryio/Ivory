import 'package:flutter/material.dart';

class IvoryGenericError extends StatelessWidget {
  final String errorMessage;
  final TextStyle textStyle;

  const IvoryGenericError({
    super.key,
    this.errorMessage = 'Something went wrong',
    this.textStyle = const TextStyle(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Text(errorMessage, style: textStyle);
  }
}
