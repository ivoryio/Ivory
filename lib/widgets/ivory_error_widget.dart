import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class IvoryErrorWidget extends StatelessWidget {
  final String error;
  const IvoryErrorWidget(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(error, style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(color: Colors.red));
  }
}
