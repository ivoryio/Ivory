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
      return DeviceBindingFetchedViewModel(
        devices: deviceBindingState.devices,
        thisDevice: deviceBindingState.thisDevice,
      );
    } else if (deviceBindingState is DeviceBindingFetchedButEmptyState) {
      return DeviceBindingFetchedButEmptyViewModel(
        thisDevice: deviceBindingState.thisDevice,
      );
    } else if (deviceBindingState is DeviceBindingDeletedState) {
      return DeviceBindingDeletedViewModel();
    } else if (deviceBindingState is DeviceBindingCreatedState) {
      return DeviceBindingCreatedViewModel();
    } else if (deviceBindingState is DeviceBindingChallengeVerifiedState) {
      return DeviceBindingChallengeVerifiedViewModel(
        thisDevice: deviceBindingState.thisDevice,
      );
    }
    return DeviceBindingInitialViewModel();
  }
}

class DeviceBindingViewModel extends Equatable {
  final List<Device>? devices;
  final Device? thisDevice;

  const DeviceBindingViewModel({this.devices, this.thisDevice});

  @override
  List<Object?> get props => [devices, thisDevice];
}

class DeviceBindingInitialViewModel extends DeviceBindingViewModel {}

class DeviceBindingLoadingViewModel extends DeviceBindingViewModel {}

class DeviceBindingErrorViewModel extends DeviceBindingViewModel {}

class DeviceBindingCreatedViewModel extends DeviceBindingViewModel {}

class DeviceBindingChallengeVerifiedViewModel extends DeviceBindingViewModel {
  const DeviceBindingChallengeVerifiedViewModel({
    required Device thisDevice,
  }) : super(thisDevice: thisDevice);

  @override
  List<Object?> get props => [thisDevice];
}

class DeviceBindingFetchedViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedViewModel({
    required List<Device> devices,
    required Device thisDevice,
  }) : super(devices: devices, thisDevice: thisDevice);

  @override
  List<Object?> get props => [devices, thisDevice];
}

class DeviceBindingFetchedButEmptyViewModel extends DeviceBindingViewModel {
  const DeviceBindingFetchedButEmptyViewModel({
    required Device thisDevice,
  }) : super(thisDevice: thisDevice);

  @override
  List<Object?> get props => [thisDevice];
}

class DeviceBindingDeletedViewModel extends DeviceBindingViewModel {}
