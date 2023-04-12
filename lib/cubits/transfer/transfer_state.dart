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

class TransferStateSetAmount extends TransferState {
  const TransferStateSetAmount({
    super.iban,
    super.name,
    super.savePayee,
    super.amount,
  });
}

class TransferStateConfirm extends TransferState {
  const TransferStateConfirm({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransferStateConfirmTan extends TransferState {
  const TransferStateConfirmTan({
    super.iban,
    super.name,
    super.amount,
    super.savePayee,
  });
}

class TransactionStateConfirmed extends TransferState {
  const TransactionStateConfirmed({
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
