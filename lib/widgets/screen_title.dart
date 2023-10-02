import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;

  const ScreenTitle(this.title, {super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Text(
        title,
        style: ClientConfig.getTextStyleScheme().heading1,
        textAlign: TextAlign.left,
      ),
    );
  }
}
