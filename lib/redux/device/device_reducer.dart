import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

import 'device_action.dart';

DeviceBindingState deviceBindingState(DeviceBindingState currentState, dynamic action) {
  if (action is DeviceBindingLoadingEventAction) {
    return DeviceBindingLoadingState();
  } else if (action is DeviceBindingFailedEventAction) {
    return DeviceBindingErrorState();
  } else if (action is DeviceBindingNotPossibleEventAction) {
    return DeviceBindingNotPossibleState(action.reason);
  } else if (action is BoundDevicesFetchedEventAction) {
    return DeviceBindingFetchedState(
        action.boundDevices, action.thisDevice, action.isBoundDevice, action.isBindingPossible ?? false);
  } else if (action is BoundDeviceDeletedEventAction) {
    return DeviceBindingDeletedState();
  } else if (action is DeviceBindingCreatedEventAction) {
    return DeviceBindingCreatedState();
  } else if (action is AuthenticationInitializedEventAction) {
    if (action.thisDevice.deviceId == '') {
      return DeviceBindingFetchedState(action.boundDevices, action.thisDevice, false, false);
    } else {
      return DeviceBindingFetchedState(action.boundDevices, action.thisDevice, true, false);
    }
  } else if (action is DeviceBindingChallengeVerifiedEventAction) {
    return DeviceBindingChallengeVerifiedState(action.thisDevice);
  } else if (action is DeviceBindingChallengeVerificationFailedEventAction) {
    return DeviceBindingVerificationErrorState(action.deviceId);
  }
  return currentState;
}
