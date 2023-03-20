import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ExpandedButton extends StatelessWidget {
  final String text;
  final bool active;
  final Function onPressed;

  const ExpandedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.active});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Color(0xff020202);
    final Color buttonColor = active ? Colors.white : Colors.transparent;
    final Color borderColor = active ? Color(0xffB9B9B9) : Colors.transparent;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(9.0)),
          color: buttonColor,
          border: Border.all(width: 1, color: borderColor),
        ),
        child: PlatformElevatedButton(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: Colors.transparent,
            child: Text(text,
                softWrap: false,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                )),
            cupertino: (context, platform) => CupertinoElevatedButtonData(
                  pressedOpacity: 0.75,
                ),
            onPressed: () => onPressed()),
      ),
    );
  }
}
