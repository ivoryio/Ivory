import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';

import '../../models/change_request/change_request_error_type.dart';

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

class TransferConfirmedState extends TransferState {
  final double amount;

  TransferConfirmedState({
    required this.amount,
  });
}

class TransferFailedState extends TransferState {
  final ChangeRequestErrorType errorType;

  TransferFailedState(this.errorType);
}
