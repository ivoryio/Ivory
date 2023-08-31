import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

class DeviceBindingPresenter {
  static DeviceBindingViewModel presentDeviceBinding({required DeviceBindingState deviceBindingState}) {
    if (deviceBindingState is DeviceBindingInitialState) {
      return DeviceBindingInitialViewModel();
    } else if (deviceBindingState is DeviceBindingLoadingState) {
      return DeviceBindingLoadingViewModel();
    } else if (deviceBindingState is DeviceBindingErrorState) {
      return DeviceBindingErrorViewModel();
    } else if (deviceBindingState is DeviceBindingFetchedState) {
      return DeviceBindingFetchedViewModel(
        deviceId: deviceBindingState.deviceId,
        deviceName: deviceBindingState.deviceName,
      );
    } else if (deviceBindingState is DeviceBindingFetchedButEmptyState) {
      return DeviceBindingFetchedButEmptyViewModel(
        deviceName: deviceBindingState.deviceName,
      );
    }
    return DeviceBindingInitialViewModel();
  }
}

class DeviceBindingViewModel extends Equatable {
  final String? deviceId;
  final String? deviceName;

  const DeviceBindingViewModel({
    this.deviceId,
    this.deviceName,
  });

  @override
  List<Object?> get props => [deviceId, deviceName];
}

class DeviceBindingInitialViewModel extends DeviceBindingViewModel {}

class DeviceBindingLoadingViewModel extends DeviceBindingViewModel {}

class DeviceBindingErrorViewModel extends DeviceBindingViewModel {}

class DeviceBindingFetchedViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedViewModel({
    required String deviceId,
    required String deviceName,
  }) : super(deviceId: deviceId, deviceName: deviceName);

  @override
  List<Object?> get props => [deviceId, deviceName];
}

class DeviceBindingFetchedButEmptyViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedButEmptyViewModel({
    required String deviceName,
  }) : super(deviceName: deviceName);

  @override
  List<Object?> get props => [deviceName];
}
