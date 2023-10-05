import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class ScreenTitle extends StatelessWidget {
  final String title;
  final EdgeInsetsGeometry? padding;
  final double scale;

  const ScreenTitle(this.title, {super.key, this.padding, this.scale = 1.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        title,
        style: ClientConfig.getTextStyleScheme().heading1,
        textAlign: TextAlign.left,
        textScaleFactor: scale,
      ),
    );
  }
}
