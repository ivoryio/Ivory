import '../../models/device.dart';

class DeviceBindingLoadingEventAction {}

class DeviceBindingFailedEventAction {}

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
  final List<Device> devices;
  final Device thisDevice;

  BoundDevicesFetchedEventAction(this.devices, this.thisDevice);
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

class BoundDevicesFetchedButEmptyEventAction {
  final Device thisDevice;

  BoundDevicesFetchedButEmptyEventAction(this.thisDevice);
}

class DeviceBoundedEventAction {}

class BoundDeviceDeletedEventAction {}

class TemporaryDeviceBindingDeletedEventAction {}
