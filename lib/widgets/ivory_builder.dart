import 'package:flutter/material.dart';

class IvoryBuilder extends StatelessWidget {
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child) builder;

  const IvoryBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
