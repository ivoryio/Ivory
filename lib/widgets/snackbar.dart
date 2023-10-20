import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

void showSnackbar(
  BuildContext context, {
  required String text,
  BorderRadiusGeometry borderRadius = const BorderRadius.all(Radius.circular(30)),
  required Color backgroundColor,
  Duration duration = const Duration(seconds: 2),
  EdgeInsets margin = const EdgeInsets.only(bottom: 24),
  Icon? icon,
  TextStyle? textStyle,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backgroundColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[icon, const SizedBox(width: 4)],
              Text(
                text,
                style: textStyle ??
                    ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                          color: Colors.white,
                          height: 1.375,
                        ),
              ),
            ],
          ),
        ),
      ]),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: margin,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
