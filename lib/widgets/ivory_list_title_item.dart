import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class IvoryListTitleItem extends StatelessWidget {
  final String title;

  const IvoryListTitleItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: ClientConfig.getTextStyleScheme().labelLarge,
      ),
    );
  }
}
