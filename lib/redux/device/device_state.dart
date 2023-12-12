import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/device_binding.dart';

import '../../models/device.dart';

abstract class DeviceBindingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceBindingInitialState extends DeviceBindingState {}

class DeviceBindingLoadingState extends DeviceBindingState {}

class DeviceBindingErrorState extends DeviceBindingState {}

class DeviceBindingNotPossibleState extends DeviceBindingState {
  final DeviceBindingNotPossibleReason reason;

  DeviceBindingNotPossibleState(this.reason);

  @override
  List<Object?> get props => [reason];
}

class DeviceBindingVerificationErrorState extends DeviceBindingState {
  final String deviceId;

  DeviceBindingVerificationErrorState(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class DeviceBindingFetchedState extends DeviceBindingState {
  final List<Device> devices;
  final Device thisDevice;
  final bool isBoundDevice;
  final bool isBindingPossible;


  DeviceBindingFetchedState(this.devices, this.thisDevice, this.isBoundDevice, this.isBindingPossible);

  @override
  List<Object?> get props => [devices, thisDevice, isBoundDevice, isBindingPossible];
}

class DeviceBindingDeletedState extends DeviceBindingState {}

class DeviceBindingCreatedState extends DeviceBindingState {}

class DeviceBindingChallengeVerifiedState extends DeviceBindingState {
  final Device thisDevice;

  DeviceBindingChallengeVerifiedState(this.thisDevice);

  @override
  List<Object?> get props => [thisDevice];
}
