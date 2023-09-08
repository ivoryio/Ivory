import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

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
  final bool isLoading;

  const Button({
    Key? key,
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
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isDisabled = onPressed == null || isLoading;
    TextStyle defaultTextStyle = TextStyle(
      color: isDisabled ? disabledTextColor : textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: fontFamily,
    );

Widget buttonChild = Stack(
      alignment: Alignment.centerRight,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: textStyle != null ? defaultTextStyle.merge(textStyle) : defaultTextStyle,
          ),
        ),
        if (isLoading)
          const Positioned(
            right: 100,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(),
            ),
          )
      ],
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
      onPressed: isDisabled ? null : (onPressed as void Function()?),
      child: buttonChild,
    );

    if (border != null) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius!)), border: border),
        child: widget,
      );
    }

    return widget;
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final Function? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: text,
      onPressed: onPressed,
      color: ClientConfig.getColorScheme().secondary,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double borderWidth;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Button(
      text: text,
      onPressed: onPressed,
      color: Colors.transparent,
      textColor: Colors.black,
      border: Border.all(color: Colors.black, width: borderWidth),
    );
  }
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
