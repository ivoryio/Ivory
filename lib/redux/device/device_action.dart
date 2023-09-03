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

class DeleteBoundDeviceCommandAction {
  final User user;
  final String deviceId;

  DeleteBoundDeviceCommandAction({
    required this.user,
    required this.deviceId,
  });
}

class FetchBoundDevicesCommandAction {}

class BoundDevicesFetchedEventAction {
  final List<Device> devices;
  final Device thisDevice;

  BoundDevicesFetchedEventAction(this.devices, this.thisDevice);
}

class BoundDevicesFetchedButEmptyEventAction {
  final Device thisDevice;

  BoundDevicesFetchedButEmptyEventAction(this.thisDevice);
}

class DeviceBoundedEventAction {}

class BoundDeviceDeletedEventAction {}
