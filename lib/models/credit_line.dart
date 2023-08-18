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
  final num minimumPercentage;

  CreditLine({
    required this.id,
    required this.dueDate,
    required this.previousBillAmount,
    required this.currentBillAmount,
    required this.outstandingAmount,
    required this.spentAmount,
    required this.accumulatedInterestAmount,
    required this.repaymentRatePercentage,
    required this.minimumPercentage,
  });

  factory CreditLine.fromJson(Map<String, dynamic> json) {
    print('CreditLine.fromJson: $json');

    return CreditLine(
      id: json['id'],
      dueDate: DateTime.parse(json['due_date']),
      previousBillAmount: AmountValue.fromJson(json['previous_bill_amount']),
      currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
      outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
      spentAmount: AmountValue.fromJson(json['spent_amount']),
      accumulatedInterestAmount: AmountValue.fromJson(json['accumulated_interest_amount']),
      repaymentRatePercentage: json['repayment_percentage_rate'],
      minimumPercentage: json['minimum_percentage'],
    );
  }

  factory CreditLine.dummy() => CreditLine(
        id: '0',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        previousBillAmount: AmountValue(
          value: 496.22,
          unit: 'cents',
          currency: 'EUR',
        ),
        currentBillAmount: AmountValue(
          value: 595.46,
          unit: 'cents',
          currency: 'EUR',
        ),
        outstandingAmount: AmountValue(
          value: 2580.37,
          unit: 'cents',
          currency: 'EUR',
        ),
        spentAmount: AmountValue(
          value: 2481.13,
          unit: 'cents',
          currency: 'EUR',
        ),
        accumulatedInterestAmount: AmountValue(
          value: 99.24,
          unit: 'cents',
          currency: 'EUR',
        ),
        repaymentRatePercentage: 20.0,
        minimumPercentage: 5.0,
      );
}
