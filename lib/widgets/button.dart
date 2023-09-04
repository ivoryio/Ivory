import 'package:flutter/material.dart';

const double _defaultFontSize = 16;
const double _defaultBorderRadius = 4.0;

class Button extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? textColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
  final String? fontFamily;
  final double? borderRadius;
  final BoxBorder? border;
  final Color? disabledColor;
  final Color? disabledTextColor;

  final Function? onPressed;

  const Button({
    super.key,
    required this.text,
    this.onPressed,
    this.border,
    this.textStyle,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.borderRadius = _defaultBorderRadius,
    this.disabledColor = Colors.grey,
    this.disabledTextColor = Colors.black54,
    this.fontSize = _defaultFontSize,
    this.fontFamily = "Proxima Nova",
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = onPressed == null;
    TextStyle defaultTextStyle = TextStyle(
      color: isDisabled ? disabledTextColor : textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    );

    Widget widget = ElevatedButton(
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
        onPressed: onPressed as void Function()?,
        child: Text(
          text,
          style: textStyle != null ? defaultTextStyle.merge(textStyle) : defaultTextStyle,
        ));

    if (border != null) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius!)), border: border),
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
    super.fontFamily,
    super.borderRadius,
    required String text,
    super.onPressed,
    super.disabledColor = Colors.black12,
    super.disabledTextColor = Colors.black26,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          color: Colors.black,
          textColor: Colors.white,
        );
}

class SecondaryButton extends Button {
  SecondaryButton({
    super.key,
    super.padding,
    super.fontSize,
    super.fontFamily,
    super.borderRadius,
    required String text,
    super.onPressed,
    super.disabledColor = Colors.black12,
    super.disabledTextColor = Colors.black26,
    TextStyle? textStyle,
  }) : super(
          text: text,
          textStyle: textStyle,
          color: Colors.transparent,
          textColor: Colors.black,
          border: Border.all(color: Colors.black),
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
        border: active ? Border.all(width: 1, color: const Color(0xffB9B9B9)) : null,
        onPressed: () {
          onPressed();
        },
      ),
    );
  }
}
