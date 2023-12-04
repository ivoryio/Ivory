import 'package:equatable/equatable.dart';

import '../../models/device.dart';

abstract class DeviceBindingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceBindingInitialState extends DeviceBindingState {}

class DeviceBindingLoadingState extends DeviceBindingState {}

class DeviceBindingErrorState extends DeviceBindingState {}

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

  DeviceBindingFetchedState(this.devices, this.thisDevice, this.isBoundDevice);

  @override
  List<Object?> get props => [devices, thisDevice, isBoundDevice];
}

class DeviceBindingDeletedState extends DeviceBindingState {}

class DeviceBindingCreatedState extends DeviceBindingState {}

class DeviceBindingChallengeVerifiedState extends DeviceBindingState {
  final Device thisDevice;

  DeviceBindingChallengeVerifiedState(this.thisDevice);

  @override
  List<Object?> get props => [thisDevice];
}
