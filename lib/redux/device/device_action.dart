import '../../models/device.dart';
import '../../models/user.dart';

class DeviceBindingLoadingEventAction {}

class DeviceBindingFailedEventAction {}

class CreateDeviceBindingCommandAction {
  final User user;

  CreateDeviceBindingCommandAction({
    required this.user,
  });
}

class VerifyDeviceBindingSignatureCommandAction {
  final User user;
  final String tan;

  VerifyDeviceBindingSignatureCommandAction({
    required this.user,
    required this.tan,
  });
}

class DeleteBoundDeviceCommandAction {
  final User user;
  final String deviceId;

  DeleteBoundDeviceCommandAction({
    required this.user,
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
