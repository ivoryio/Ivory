import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Color borderColor;
  final Function? onTap;
  final Widget child;
  final EdgeInsets? customPadding;
  final double? customHeight;

  const BorderedContainer({
    super.key,
    this.onTap,
    this.borderColor = Colors.black,
    this.customPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.customHeight = 68,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap != null ? onTap!() : null,
      child: Container(
        height: customHeight,
        padding: customPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: child,
      ),
    );
  }
}
