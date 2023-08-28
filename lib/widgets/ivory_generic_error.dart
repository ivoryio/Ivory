import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class IvoryGenericError extends StatelessWidget {
  final String errorMessage;
  final TextStyle? textStyle;

  const IvoryGenericError({
    super.key,
    this.errorMessage = 'Something went wrong',
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: textStyle ?? ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(color: Colors.red),
    );
  }
}
