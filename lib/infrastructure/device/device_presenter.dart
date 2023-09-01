import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

import '../../models/device.dart';

class DeviceBindingPresenter {
  static DeviceBindingViewModel presentDeviceBinding({required DeviceBindingState deviceBindingState}) {
    if (deviceBindingState is DeviceBindingInitialState) {
      return DeviceBindingInitialViewModel();
    } else if (deviceBindingState is DeviceBindingLoadingState) {
      return DeviceBindingLoadingViewModel();
    } else if (deviceBindingState is DeviceBindingErrorState) {
      return DeviceBindingErrorViewModel();
    } else if (deviceBindingState is DeviceBindingFetchedState) {
      return DeviceBindingFetchedViewModel(devices: deviceBindingState.devices);
    } else if (deviceBindingState is DeviceBindingFetchedButEmptyState) {
      return DeviceBindingFetchedButEmptyViewModel(devices: deviceBindingState.devices);
    }
    return DeviceBindingInitialViewModel();
  }
}

class DeviceBindingViewModel extends Equatable {
  final List<Device>? devices;

  const DeviceBindingViewModel({this.devices});

  @override
  List<Object?> get props => [devices];
}

class DeviceBindingInitialViewModel extends DeviceBindingViewModel {}

class DeviceBindingLoadingViewModel extends DeviceBindingViewModel {}

class DeviceBindingErrorViewModel extends DeviceBindingViewModel {}

class DeviceBindingFetchedViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedViewModel({
    required List<Device> devices,
  }) : super(devices: devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceBindingFetchedButEmptyViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedButEmptyViewModel({
    required List<Device> devices,
  }) : super(devices: devices);

  @override
  List<Object?> get props => [devices];
}
