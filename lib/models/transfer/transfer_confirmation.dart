import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';

class TransferConfirmation extends Equatable {
  final bool success;
  final ReferenceAccountTransfer? transfer;

  const TransferConfirmation({
    required this.success,
    this.transfer,
  });

  @override
  List<Object?> get props => [];
}
