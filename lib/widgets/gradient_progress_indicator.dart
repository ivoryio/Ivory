import 'package:flutter/material.dart';

class GradientProgressIndicator extends StatelessWidget {
  final int percent;
  final LinearGradient gradient;
  final Color fillColor;

  const GradientProgressIndicator(
      {required this.percent,
        required this.gradient,
        required this.fillColor,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: percent,
          fit: FlexFit.tight,
          child:  Container(
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: percent == 0
                  ? const BorderRadius.all(Radius.circular(4))
                  : const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  topLeft: Radius.circular(4)),
            ),
            child: const SizedBox(height: 8.0),
          ),
        ),
        Flexible(
          fit: FlexFit.tight,
          flex: 100 - percent,
          child:  Container(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: percent == 100
                  ? const BorderRadius.all(Radius.circular(4))
                  : const BorderRadius.only(
                  bottomRight: Radius.circular(4),
                  topRight: Radius.circular(4)),
            ),
            child: const SizedBox(height: 8.0),
          ),
        ),
      ],
    );
  }
}