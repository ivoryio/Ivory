import 'package:equatable/equatable.dart';

import '../../models/device.dart';

abstract class DeviceBindingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceBindingInitialState extends DeviceBindingState {}

class DeviceBindingLoadingState extends DeviceBindingState {}

class DeviceBindingErrorState extends DeviceBindingState {}

class DeviceBindingFetchedState extends DeviceBindingState {
  final List<Device> devices;
  final Device thisDevice;

  DeviceBindingFetchedState(this.devices, this.thisDevice);

  @override
  List<Object?> get props => [devices, thisDevice];
}

class DeviceBindingFetchedButEmptyState extends DeviceBindingState {
  final Device thisDevice;

  DeviceBindingFetchedButEmptyState(this.thisDevice);

  @override
  List<Object?> get props => [thisDevice];
}

class DeviceBindingDeletedState extends DeviceBindingState {}
