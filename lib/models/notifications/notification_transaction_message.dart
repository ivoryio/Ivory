import 'package:equatable/equatable.dart';

class NotificationTransactionMessage extends Equatable {
  final String merchantName;
  final String amountValue;
  final String amountCurrency;
  final String amountUnit;
  final String changeRequestId;
  final String declineChangeRequestId;
  final DateTime dateTime;

  const NotificationTransactionMessage({
    required this.merchantName,
    required this.amountValue,
    required this.amountCurrency,
    required this.amountUnit,
    required this.changeRequestId,
    required this.declineChangeRequestId,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [
        merchantName,
        amountValue,
        amountCurrency,
        amountUnit,
        changeRequestId,
        declineChangeRequestId,
      ];
}
