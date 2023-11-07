import 'dart:async';
import 'dart:ui';

class Debouncer {
  Timer? _timer;

  final int minutes;
  final int seconds;
  final int milliseconds;

  Debouncer({
    this.minutes = 0,
    this.seconds = 0,
    this.milliseconds = 0,
  });

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(
      Duration(minutes: minutes, seconds: seconds, milliseconds: milliseconds),
      action,
    );
  }

  void cancel() {
    _timer?.cancel();
  }
}
