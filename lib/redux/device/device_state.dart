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

  DeviceBindingFetchedState(this.devices);

  @override
  List<Object?> get props => [devices];
}

class DeviceBindingFetchedButEmptyState extends DeviceBindingState {
  final List<Device> devices;

  DeviceBindingFetchedButEmptyState(this.devices);

  @override
  List<Object?> get props => [devices];
}
