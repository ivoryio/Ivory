import 'package:equatable/equatable.dart';

abstract class TransferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransferInitialState extends TransferState {}

class TransferLoadingState extends TransferState {}

class TransferNeedConfirmationState extends TransferState {}

class TransferConfirmationLoadingState extends TransferNeedConfirmationState {}

class TransferConfirmedState extends TransferState {}

class TransferFailedState extends TransferState {}
