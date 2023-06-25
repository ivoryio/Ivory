import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../widgets/screen.dart';

class CountDownScreen extends StatefulWidget {
  const CountDownScreen({super.key});

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  @override
  Widget build(BuildContext context) {
    int currentTimeInSeconds() {
      int ms = (DateTime.now()).millisecondsSinceEpoch;
      return (ms / 1000).round();
    }

    int startTimer = currentTimeInSeconds();
    int duration = 180 * 60 * 1000;

    return Screen(
      hideBottomNavbar: true,
      title: "Countdown Screen",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Wait until the time\nruns out.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Center(
            child: Text(
              '${startTimer.toString()} \n ${duration.toString()}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
