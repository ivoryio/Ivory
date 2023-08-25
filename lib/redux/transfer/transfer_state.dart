import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';

abstract class TransferState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransferInitialState extends TransferState {}

class TransferLoadingState extends TransferState {}

class TransferNeedConfirmationState extends TransferState {
  final TransferAuthorizationRequest transferAuthorizationRequest;

  TransferNeedConfirmationState({
    required this.transferAuthorizationRequest,
  });
}

class TransferConfirmedState extends TransferState {}

class TransferFailedState extends TransferState {}
