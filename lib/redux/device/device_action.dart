class DeviceBindingLoadingEventAction {}

class DeviceBindingFailedEventAction {}

class CreateDeviceBindingCommandAction {
  final String personId;

  CreateDeviceBindingCommandAction({
    required this.personId,
  });
}

class FetchBoundDevicesCommandAction {}

class BoundDevicesFetchedEventAction {
  final String deviceId;
  final String deviceName;

  BoundDevicesFetchedEventAction({
    required this.deviceId,
    required this.deviceName,
  });
}

class BoundDevicesFetchedButEmptyEventAction {
  final String deviceName;

  BoundDevicesFetchedButEmptyEventAction({
    required this.deviceName,
  });
}

class VerifyDeviceBindingEventAction {
  final String tan;

  VerifyDeviceBindingEventAction({
    required this.tan,
  });
}

class CreateRestrictedKeyEventAction {}
