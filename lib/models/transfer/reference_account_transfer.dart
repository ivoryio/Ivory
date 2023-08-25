import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/currency/currency.dart';

class ReferenceAccountTransfer extends Equatable {
  final String description;
  final ReferenceAccountTransferAmount amount;

  const ReferenceAccountTransfer({
    required this.description,
    required this.amount,
  });

  @override
  List<Object?> get props => [description, amount];
}

class ReferenceAccountTransferAmount extends Equatable {
  final double value;
  final Currency currency;

  const ReferenceAccountTransferAmount({
    required this.value,
    this.currency = Currency.euro,
  });

  @override
  List<Object?> get props => [value, currency];
}
