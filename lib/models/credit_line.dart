import 'amount_value.dart';

class CreditLine {
  final String id;
  final DateTime dueDate;
  final AmountValue previousBillAmount;
  final AmountValue currentBillAmount;
  final AmountValue outstandingAmount;
  final AmountValue accumulatedInterestAmount;

  CreditLine({
    required this.id,
    required this.dueDate,
    required this.previousBillAmount,
    required this.currentBillAmount,
    required this.outstandingAmount,
    required this.accumulatedInterestAmount,
  });

  factory CreditLine.fromJson(Map<String, dynamic> json) {
    print('CreditLine.fromJson: $json');

    return CreditLine(
      id: json['id'],
      dueDate: DateTime.parse(json['due_date']),
      previousBillAmount: AmountValue.fromJson(json['previous_bill_amount']),
      currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
      outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
      accumulatedInterestAmount: AmountValue.fromJson(json['accumulated_interest_amount']),
    );
  }
}
