import 'dart:async';

import 'package:flutter/material.dart';

import '../config.dart';

class CircularCountdownProgress extends StatefulWidget {
  final CountdownTimerController? controller;
  final Duration? duration;
  final VoidCallback? onCompleted;

  const CircularCountdownProgress({
    super.key,
    this.onCompleted,
    this.controller,
    this.duration,
  }) : assert(controller != null || duration != null);

  @override
  State<CircularCountdownProgress> createState() => _CircularCountdownProgressState();
}

class _CircularCountdownProgressState extends State<CircularCountdownProgress> {
  late CountdownTimerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? CountdownTimerController(duration: widget.duration!);
    if (widget.onCompleted != null) {
      _controller.onCompleted = widget.onCompleted!;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "${_controller.formattedRemainingMinutes}:${_controller.formattedRemainingSeconds}",
                style: ClientConfig.getTextStyleScheme()
                    .labelSmall
                    .copyWith(color: ClientConfig.getCustomColors().neutral900),
              ),
            ),
          ),
          Positioned.fill(
            child: CircularProgressIndicator(
              strokeWidth: 7,
              value: _controller.remainingPercent,
              backgroundColor: ClientConfig.getCustomColors().neutral200,
              valueColor: AlwaysStoppedAnimation<Color>(ClientConfig.getColorScheme().secondary),
            ),
          ),
        ],
      ),
    );
  }
}

class CountdownTimerController extends ValueNotifier<Duration> {
  final Duration duration;
  final Duration stepDuration;

  CountdownTimerController({
    required this.duration,
    this.stepDuration = const Duration(seconds: 1),
  }) : super(duration);

  set onCompleted(VoidCallback onCompleted) {
    _onCompleted = onCompleted;
  }

  Timer? _timer;
  VoidCallback? _onCompleted;

  bool get isCompleted => value.inSeconds == 0;
  Duration get remainingDuration => value;

  double get remainingPercent => value.inSeconds / duration.inSeconds;

  int get remainingSeconds => value.inSeconds % 60;
  int get remainingMinutes => value.inMinutes;

  String get formattedRemainingMinutes => remainingMinutes.toString().padLeft(2, '0');
  String get formattedRemainingSeconds => remainingSeconds.toString().padLeft(2, '0');
  String get formattedRemainingDuration => '$formattedRemainingMinutes:$formattedRemainingSeconds';

  void start() {
    _timer?.cancel();

    _timer = Timer.periodic(stepDuration, (timer) {
      if (value.inSeconds == 0) {
        timer.cancel();
        _onCompleted?.call();
      } else {
        value = value - stepDuration;
      }
    });
  }

  void stop() {
    _timer?.cancel();
  }

  void reset() {
    value = duration;
    start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
