import 'package:solarisdemo/models/device_binding.dart';

import '../../models/device.dart';

class DeviceBindingLoadingEventAction {}

class DeviceBindingFailedEventAction {}

class DeviceBindingNotPossibleEventAction {
  final DeviceBindingNotPossibleReason reason;

  DeviceBindingNotPossibleEventAction({
    required this.reason,
  });
}

class DeviceBindingCheckIfPossibleCommandAction {}

class CreateDeviceBindingCommandAction {}

class VerifyDeviceBindingSignatureCommandAction {
  final String tan;

  VerifyDeviceBindingSignatureCommandAction({
    required this.tan,
  });
}

class DeleteBoundDeviceCommandAction {
  final String deviceId;

  DeleteBoundDeviceCommandAction({
    required this.deviceId,
  });
}

class DeleteIncompleteDeviceBindingCommandAction {}

class FetchBoundDevicesCommandAction {}

class BoundDevicesFetchedEventAction {
  final List<Device> boundDevices;
  final Device thisDevice;
  final bool isBoundDevice;
  final bool? isBindingPossible;

  BoundDevicesFetchedEventAction({
    required this.boundDevices,
    required this.thisDevice,
    required this.isBoundDevice,
    this.isBindingPossible,

  });
}

class DeviceBindingCreatedEventAction {}

class DeviceBindingChallengeVerificationFailedEventAction {
  final String deviceId;

  DeviceBindingChallengeVerificationFailedEventAction(this.deviceId);
}

class DeviceBindingChallengeVerifiedEventAction {
  final Device thisDevice;

  DeviceBindingChallengeVerifiedEventAction(this.thisDevice);
}

class DeviceBoundedEventAction {}

class BoundDeviceDeletedEventAction {}

class TemporaryDeviceBindingDeletedEventAction {}
