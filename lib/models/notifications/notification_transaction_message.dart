import 'package:equatable/equatable.dart';

class NotificationTransactionMessage extends Equatable {
  final String cardId;
  final String amountUnit;
  final DateTime dateTime;
  final String amountValue;
  final String merchantName;
  final String amountCurrency;
  final String changeRequestId;
  final String declineChangeRequestId;

  const NotificationTransactionMessage({
    required this.cardId,
    required this.dateTime,
    required this.amountUnit,
    required this.amountValue,
    required this.merchantName,
    required this.amountCurrency,
    required this.changeRequestId,
    required this.declineChangeRequestId,
  });

  @override
  List<Object?> get props => [
        cardId,
        amountUnit,
        amountValue,
        merchantName,
        amountCurrency,
        changeRequestId,
        declineChangeRequestId,
      ];
}
