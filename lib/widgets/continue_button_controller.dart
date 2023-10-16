import 'package:flutter/foundation.dart';

class ContinueButtonController extends ValueNotifier<bool> {
  ContinueButtonController({bool isEnabled = false}) : super(isEnabled);

  get isEnabled => value;

  void setEnabled() {
    if (value == true) {
      return;
    }

    value = true;
    notifyListeners();
  }

  void setDisabled() {
    if (value == false) {
      return;
    }

    value = false;
    notifyListeners();
  }

  void toggle() {
    isEnabled ? setDisabled() : setEnabled();
  }
}
