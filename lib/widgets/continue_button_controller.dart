import 'package:flutter/foundation.dart';

class ContinueButtonState {
  final bool isEnabled;
  final bool isLoading;

  ContinueButtonState({this.isEnabled = false, this.isLoading = false});

  ContinueButtonState copyWith({bool? isEnabled, bool? isLoading}) {
    return ContinueButtonState(
      isEnabled: isEnabled ?? this.isEnabled,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ContinueButtonController extends ValueNotifier<ContinueButtonState> {
  ContinueButtonController({bool isEnabled = false, bool isLoading = false})
      : super(ContinueButtonState(isEnabled: isEnabled, isLoading: isLoading));

  ContinueButtonState get state => value;

  bool get isEnabled => value.isEnabled;
  bool get isLoading => value.isLoading;

  void setEnabled() {
    value = state.copyWith(isEnabled: true, isLoading: false);
    notifyListeners();
  }

  void setDisabled() {
    value = value.copyWith(isEnabled: false, isLoading: false);
    notifyListeners();
  }

  void setLoading() {
    if (state.isLoading == true) {
      return;
    }

    value = value.copyWith(isLoading: true);
    notifyListeners();
  }

  void toggle() {
    isEnabled ? setDisabled() : setEnabled();
  }
}
