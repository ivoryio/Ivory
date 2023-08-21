import 'amount_value.dart';

class CreditLine {
  final String id;
  final DateTime dueDate;
  final AmountValue previousBillAmount;
  final AmountValue currentBillAmount;
  final AmountValue outstandingAmount;
  final AmountValue spentAmount;
  final AmountValue accumulatedInterestAmount;
  final num repaymentRatePercentage;
  final num interestRate;

  CreditLine({
    required this.id,
    required this.dueDate,
    required this.previousBillAmount,
    required this.currentBillAmount,
    required this.outstandingAmount,
    required this.spentAmount,
    required this.accumulatedInterestAmount,
    required this.repaymentRatePercentage,
    required this.interestRate,
  });

  factory CreditLine.fromJson(Map<String, dynamic> json) => CreditLine(
        id: json['id'],
        dueDate: DateTime.parse(json['due_date']),
        previousBillAmount: AmountValue.fromJson(json['previous_bill_amount']),
        currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
        outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
        spentAmount: AmountValue.fromJson(json['amount_spent']),
        accumulatedInterestAmount: AmountValue.fromJson(json['accumulated_interest_amount']),
        repaymentRatePercentage: json['minimum_percentage'],
        interestRate: json['interest_rate'],
      );

  factory CreditLine.empty() => CreditLine(
        id: '0',
        dueDate: DateTime.now(),
        previousBillAmount: AmountValue.empty(),
        currentBillAmount: AmountValue.empty(),
        outstandingAmount: AmountValue.empty(),
        spentAmount: AmountValue.empty(),
        accumulatedInterestAmount: AmountValue.empty(),
        repaymentRatePercentage: 0.0,
        interestRate: 0.0,
      );
}
