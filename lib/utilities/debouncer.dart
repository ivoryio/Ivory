import 'dart:async';
import 'dart:ui';

class Debouncer {
  Timer? _timer;
  final Duration duration;

  Debouncer(this.duration);

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(duration, action);
  }

  void cancel() {
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}
