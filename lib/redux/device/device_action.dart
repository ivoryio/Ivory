class DeviceLoadingEventAction {}

class DeviceFailedEventAction {}

class CreateDeviceBindingCommandAction {
  final String personId;

  CreateDeviceBindingCommandAction({
    required this.personId,
  });
}

class VerifyDeviceBindingEventAction {
  final String tan;

  VerifyDeviceBindingEventAction({
    required this.tan,
  });
}

class CreateRestrictedKeyEventAction {}
