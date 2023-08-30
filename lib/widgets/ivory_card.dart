import 'package:flutter/material.dart';

class IvoryCard extends StatelessWidget {
  final BorderRadiusGeometry borderRadius;
  final Color color;
  final Widget child;
  final EdgeInsets padding;

  const IvoryCard({
    super.key,
    required this.child,
    this.color = const Color(0xFFF8F9FA),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: color,
      ),
      padding: padding,
      child: child,
    );
  }
}
