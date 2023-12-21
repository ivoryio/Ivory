import 'dart:async';

import 'package:flutter/material.dart';

import '../config.dart';

class CircularCountdownProgress extends StatelessWidget {
  final CountdownTimerController controller;
  final VoidCallback? onCompleted;

  const CircularCountdownProgress({
    super.key,
    required this.controller,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    onCompleted != null ? controller.onCompletedTimer = onCompleted : null;

    return ListenableBuilder(
      listenable: controller,
      builder: (build, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  controller.formattedRemainingDuration.toString(),
                  style: ClientConfig.getTextStyleScheme()
                      .labelSmall
                      .copyWith(color: ClientConfig.getCustomColors().neutral900),
                ),
              ),
            ),
            Positioned.fill(
              child: CircularProgressIndicator(
                strokeWidth: 7,
                value: controller.remainingPercent,
                backgroundColor: ClientConfig.getCustomColors().neutral200,
                valueColor: AlwaysStoppedAnimation<Color>(ClientConfig.getColorScheme().secondary),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CountdownTimerController extends ValueNotifier<Duration> {
  final Duration duration;
  final Duration stepDuration;

  CountdownTimerController({
    this.duration = const Duration(seconds: 60),
    this.stepDuration = const Duration(seconds: 1),
  }) : super(duration);

  Timer? _timer;
  VoidCallback? onCompletedTimer;

  int get remainingSeconds => value.inSeconds % 60;
  int get remainingMinutes => value.inMinutes;
  double get remainingPercent => value.inSeconds / duration.inSeconds;

  String get formattedRemainingSeconds => remainingSeconds.toString().padLeft(2, '0');
  String get formattedRemainingMinutes => remainingMinutes.toString().padLeft(2, '0');
  String get formattedRemainingDuration => '$formattedRemainingMinutes:$formattedRemainingSeconds';

  void start() {
    stop();

    _timer = Timer.periodic(stepDuration, (timer) {
      if (value.inSeconds == 0) {
        stop();
        if (onCompletedTimer != null) {
          onCompletedTimer!();
        }
      } else {
        value = value - stepDuration;
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void restart() {
    value = duration;
    start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
