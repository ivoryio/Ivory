import 'dart:async';

import 'package:flutter/material.dart';

class CircularCountdownProgress extends StatefulWidget {
  final Duration? duration;
  final Function? onCompleted;

  const CircularCountdownProgress({
    super.key,
    this.duration = const Duration(seconds: 5),
    this.onCompleted,
  });

  @override
  State<CircularCountdownProgress> createState() =>
      _CircularCountdownProgressState();
}

class _CircularCountdownProgressState extends State<CircularCountdownProgress> {
  late int _remainingTime;
  late Timer _timer;
  late bool _isRunning;
  late String _showValue;

  @override
  void initState() {
    super.initState();
    widget.duration;
    _remainingTime = widget.duration!.inSeconds;
    _isRunning = false;
    _showValue = convertNumberToMinutesAndSeconds(widget.duration!);
    _handleTap();
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _showValue = convertNumberToMinutesAndSeconds(_remainingTime);
        } else {
          _stopTimer();
          if (widget.onCompleted != null) {
            widget.onCompleted!();
          }
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();

    setState(() {
      _isRunning = false;
      _remainingTime = 0;
    });
  }

  void _handleTap() {
    if (!_isRunning) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  convertNumberToMinutesAndSeconds(dynamic valueToConvert) {
    int totalSeconds;

    if (valueToConvert is Duration) {
      totalSeconds = valueToConvert.inSeconds;
    } else if (valueToConvert is int) {
      totalSeconds = valueToConvert;
    } else if (valueToConvert <= 0) {
      return '00:00';
    } else {
      return '00:00';
    }

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    String formatMinutes = minutes.toString().padLeft(2, '0');
    String formatSeconds = seconds.toString().padLeft(2, '0');

    return '$formatMinutes:$formatSeconds';
  }

  @override
  Widget build(BuildContext context) {
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
              _isRunning ? _showValue : '00:00',
              style: const TextStyle(
                fontSize: 14,
                height: 18 / 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF15141E),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: CircularProgressIndicator(
            strokeWidth: 7,
            value: widget.duration!.inSeconds > 0
                ? _remainingTime / widget.duration!.inSeconds
                : 0,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
          ),
        ),
      ],
    );
  }
}
