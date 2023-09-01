import 'package:equatable/equatable.dart';

abstract class TransactionApprovalState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionApprovalInitialState extends TransactionApprovalState {}

class TransactionApprovalLoadingState extends TransactionApprovalState {}

class TransactionApprovalChallengeFetchedState extends TransactionApprovalState {
  final String stringToSign;

  TransactionApprovalChallengeFetchedState({
    required this.stringToSign,
  });

  @override
  List<Object> get props => [stringToSign];
}

class TransactionApprovalSucceedState extends TransactionApprovalState {}

class TransactionApprovalFailedState extends TransactionApprovalState {}

class TransactionApprovalDeviceNotBoundedState extends TransactionApprovalState {}
