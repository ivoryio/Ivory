import 'package:solarisdemo/redux/device/device_state.dart';

import 'device_action.dart';

DeviceBindingState deviceBindingState(DeviceBindingState currentState, dynamic action) {
  if (action is DeviceBindingLoadingEventAction) {
    return DeviceBindingLoadingState();
  } else if (action is DeviceBindingFailedEventAction) {
    return DeviceBindingErrorState();
  } else if (action is BoundDevicesFetchedEventAction) {
    return DeviceBindingFetchedState(action.devices, action.thisDevice);
  } else if (action is BoundDevicesFetchedButEmptyEventAction) {
    return DeviceBindingFetchedButEmptyState(action.thisDevice);
  } else if (action is BoundDeviceDeletedEventAction) {
    return DeviceBindingDeletedState();
  }
  return currentState;
}
