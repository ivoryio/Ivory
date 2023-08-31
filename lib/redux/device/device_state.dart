import 'package:equatable/equatable.dart';

abstract class DeviceBindingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DeviceBindingInitialState extends DeviceBindingState {}

class DeviceBindingLoadingState extends DeviceBindingState {}

class DeviceBindingErrorState extends DeviceBindingState {}

class DeviceBindingFetchedState extends DeviceBindingState {
  final String deviceId;
  final String deviceName;

  DeviceBindingFetchedState(
    this.deviceId,
    this.deviceName,
  );

  @override
  List<Object?> get props => [deviceId, deviceName];
}

class DeviceBindingFetchedButEmptyState extends DeviceBindingState {
  final String deviceName;

  DeviceBindingFetchedButEmptyState(
    this.deviceName,
  );

  @override
  List<Object?> get props => [deviceName];
}
