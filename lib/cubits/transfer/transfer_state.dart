part of 'transfer_cubit.dart';

abstract class TransferState extends Equatable {
  final String? iban;
  final String? name;
  final double? amount;
  final bool? savePayee;

  const TransferState({
    this.iban,
    this.name,
    this.amount,
    this.savePayee,
  });

  @override
  List<Object> get props => [];
}

class TransferInitialState extends TransferState {
  const TransferInitialState({
    super.iban,
    super.name,
    super.savePayee,
    super.amount,
  });
}

class TransferSetAmountState extends TransferState {
  const TransferSetAmountState({
    super.iban,
    super.name,
    super.savePayee,
    super.amount,
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
    super.amount,
    super.savePayee,
  });
}
