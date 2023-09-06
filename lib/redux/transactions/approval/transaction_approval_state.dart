import 'package:equatable/equatable.dart';

abstract class TransactionApprovalState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionApprovalInitialState extends TransactionApprovalState {}

class TransactionApprovalLoadingState extends TransactionApprovalState {}

class TransactionApprovalAuthorizedState extends TransactionApprovalState {
  final String stringToSign;
  final String deviceId;
  final String deviceData;
  final String changeRequestId;

  TransactionApprovalAuthorizedState({
    required this.stringToSign,
    required this.deviceId,
    required this.deviceData,
    required this.changeRequestId,
  });

  @override
  List<Object> get props => [stringToSign, deviceId, deviceData, changeRequestId];
}

class TransactionApprovalSucceededState extends TransactionApprovalState {}

class TransactionApprovalRejectedState extends TransactionApprovalState {}

class TransactionApprovalFailedState extends TransactionApprovalState {}

class TransactionApprovalDeviceNotBoundedState extends TransactionApprovalState {}
