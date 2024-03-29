import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/device_binding.dart';
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
        isBoundDevice: deviceBindingState.isBoundDevice,
        isBindingPossible: deviceBindingState.isBindingPossible,
      );
    } else if (deviceBindingState is DeviceBindingDeletedState) {
      return DeviceBindingDeletedViewModel();
    } else if (deviceBindingState is DeviceBindingCreatedState) {
      return DeviceBindingCreatedViewModel();
    } else if (deviceBindingState is DeviceBindingChallengeVerifiedState) {
      return DeviceBindingChallengeVerifiedViewModel(
        thisDevice: deviceBindingState.thisDevice,
      );
    } else if (deviceBindingState is DeviceBindingVerificationErrorState) {
      return DeviceBindingVerificationErrorViewModel(
        deviceId: deviceBindingState.deviceId,
      );
    } else if (deviceBindingState is DeviceBindingNotPossibleState) {
      return DeviceBindingNotPossibleViewModel(
        reason: deviceBindingState.reason,
      );
    }

    return DeviceBindingInitialViewModel();
  }
}

class DeviceBindingViewModel extends Equatable {
  final List<Device>? devices;
  final Device? thisDevice;
  final String? deviceId;
  final bool? isBoundDevice;
  final bool? isBindingPossible;
  final DeviceBindingNotPossibleReason? reason;

  const DeviceBindingViewModel(
      {this.devices, this.thisDevice, this.deviceId, this.isBoundDevice, this.reason, this.isBindingPossible});

  @override
  List<Object?> get props => [devices, thisDevice, deviceId, isBoundDevice, reason, isBindingPossible];
}

class DeviceBindingInitialViewModel extends DeviceBindingViewModel {}

class DeviceBindingNotPossibleViewModel extends DeviceBindingViewModel {
  const DeviceBindingNotPossibleViewModel({
    required DeviceBindingNotPossibleReason reason,
  }) : super(reason: reason);

  @override
  List<Object?> get props => [reason];
}

class DeviceBindingLoadingViewModel extends DeviceBindingViewModel {}

class DeviceBindingErrorViewModel extends DeviceBindingViewModel {}

class DeviceBindingVerificationErrorViewModel extends DeviceBindingViewModel {
  const DeviceBindingVerificationErrorViewModel({
    required String deviceId,
  }) : super(deviceId: deviceId);

  @override
  List<Object?> get props => [deviceId];
}

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
    required bool isBoundDevice,
    required bool isBindingPossible,
  }) : super(
            devices: devices,
            thisDevice: thisDevice,
            isBoundDevice: isBoundDevice,
            isBindingPossible: isBindingPossible);

  @override
  List<Object?> get props => [devices, thisDevice, isBoundDevice, isBindingPossible];
}

class DeviceBindingDeletedViewModel extends DeviceBindingViewModel {}
