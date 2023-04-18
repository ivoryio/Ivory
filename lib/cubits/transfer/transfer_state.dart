part of 'transfer_cubit.dart';

abstract class TransferState extends Equatable {
  final String? iban;
  final String? name;
  final double? amount;
  final bool? savePayee;
  final String? changeRequestId;
  final String? token; //for testing purposes, to be removed

  const TransferState({
    this.iban,
    this.name,
    this.token,
    this.amount,
    this.savePayee,
    this.changeRequestId,
  });

  @override
  List<Object> get props => [];
}

class TransferInitialState extends TransferState {
  const TransferInitialState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransferSetAmountState extends TransferState {
  const TransferSetAmountState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransferConfirmState extends TransferState {
  const TransferConfirmState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransferConfirmTanState extends TransferState {
  const TransferConfirmTanState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
    super.changeRequestId,
    super.token, //for testing purposes, to be removed
  });
}

class TransferConfirmedState extends TransferState {
  const TransferConfirmedState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransferLoadingState extends TransferState {
  const TransferLoadingState({
    super.iban,
    super.name,
    super.token,
    super.amount,
    super.savePayee,
    super.changeRequestId,
  });
}

class TransferErrorState extends TransferState {
  final String message;

  const TransferErrorState({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
    required this.message,
  });
}
