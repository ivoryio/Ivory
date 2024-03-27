import 'package:flutter/material.dart';

class ButtonWithIcon extends StatelessWidget {
  final Widget
      iconWidget; // This can be Image.asset, Icon, or any other widget.
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final BorderRadiusGeometry borderRadius;
  final double horizontalPadding;
  final double verticalPadding;

  const ButtonWithIcon({
    Key? key,
    required this.iconWidget,
    required this.text,
    this.textStyle,
    this.onPressed,
    this.buttonColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.horizontalPadding = 24.0,
    this.verticalPadding = 8.0,
  }) : super(key: key);

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
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8.0),
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
