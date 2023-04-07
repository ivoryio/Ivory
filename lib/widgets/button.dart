import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

const double _defaultFontSize = 15;
const double _defaultBorderRadius = 8.0;

class Button extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final double? borderRadius;
  final BoxBorder? border;

  final Function onPressed;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.border,
    this.textStyle,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = _defaultBorderRadius,
    this.fontSize = _defaultFontSize,
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    TextStyle defaultTextStyle = TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    Widget widget = PlatformElevatedButton(
      color: color,
      child: Text(
        text,
        style: textStyle != null
            ? defaultTextStyle.merge(textStyle)
            : defaultTextStyle,
      ),
      cupertino: (context, platform) => CupertinoElevatedButtonData(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
        minSize: 0,
        padding: padding,
      ),
      material: (context, platform) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: padding,
          backgroundColor: color,
          foregroundColor: textColor,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
          ),
        ),
      ),
      onPressed: () {
        onPressed();
      },
    );

    if (border != null) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius!)),
            border: border),
        child: widget,
      );
    }

    return widget;
  }
}

class PrimaryButton extends Button {
  const PrimaryButton({
    super.key,
    super.border,
    super.padding,
    super.fontSize,
    super.borderRadius,
    required String text,
    required super.onPressed,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          color: Colors.black,
          textColor: Colors.white,
        );
}

class SecondaryButton extends Button {
  const SecondaryButton({
    super.key,
    super.border,
    super.padding,
    super.fontSize,
    super.borderRadius,
    required String text,
    required super.onPressed,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          color: const Color(0xff747474),
          textColor: Colors.white,
        );
}

class TabExpandedButton extends StatelessWidget {
  final String text;
  final bool active;
  final Function onPressed;
  final TextStyle? textStyle;

  const TabExpandedButton({
    super.key,
    this.textStyle,
    required this.active,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Button(
        text: text,
        padding: const EdgeInsets.symmetric(vertical: 6),
        color: active ? Colors.white : Colors.transparent,
        textColor: const Color(0xff020202),
        border: active
            ? Border.all(width: 1, color: const Color(0xffB9B9B9))
            : null,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
