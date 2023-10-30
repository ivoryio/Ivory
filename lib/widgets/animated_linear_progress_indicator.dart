import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';

class AnimatedLinearProgressIndicator extends StatelessWidget {
  final double begin;
  final double value;
  final Duration duration;
  final Color? color;
  final Color? backgroundColor;

  const AnimatedLinearProgressIndicator({
    super.key,
    this.begin = 0,
    this.value = 1,
    this.duration = const Duration(seconds: 1),
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: Curves.easeInOut,
      tween: Tween<double>(
        begin: begin,
        end: value,
      ),
      builder: (context, value, _) => LinearProgressIndicator(
        value: value,
        color: color ?? ClientConfig.getColorScheme().secondary,
        backgroundColor: backgroundColor ?? ClientConfig.getCustomColors().neutral200,
      ),
    );
  }

  factory AnimatedLinearProgressIndicator.step({
    required int current,
    required int totalSteps,
    bool isCompleted = false,
  }) {
    const firstStepPercent = 5 / 100;

    double begin, stepValue;

    if (current == 0) {
      begin = 0;
      stepValue = 0;
    } else if (current == 1) {
      begin = 0;
      stepValue = firstStepPercent;
    } else if (current == 2) {
      begin = firstStepPercent;
      stepValue = (current - 1) / totalSteps;
    } else {
      begin = (current - 2) / totalSteps;
      stepValue = (current - (isCompleted ? 0 : 1)) / totalSteps;
    }

    return AnimatedLinearProgressIndicator(
      begin: begin,
      value: stepValue,
    );
  }
}
