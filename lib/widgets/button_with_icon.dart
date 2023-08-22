import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final Widget
      iconWidget; // This can be Image.asset, Icon, or any other widget.
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final BorderRadiusGeometry borderRadius;

  const ButtonWithIcon({
    super.key,
    required this.iconWidget,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.buttonColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 12.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8.0), // Spacing between iconWidget and text
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
