import 'package:flutter/material.dart';

class CustomBuilder extends StatelessWidget {
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const CustomBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
