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

class FetchBoundDevicesCommandAction {}

class BoundDevicesFetchedEventAction {
  final List<Device> devices;

  BoundDevicesFetchedEventAction(this.devices);
}

class BoundDevicesFetchedButEmptyEventAction {
  final List<Device> devices;

  BoundDevicesFetchedButEmptyEventAction(this.devices);
}

class DeviceBoundedEventAction {}

