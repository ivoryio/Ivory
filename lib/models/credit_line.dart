import 'account_data.dart';
import 'amount_value.dart';

class CreditLine {
  final String id;
  final DateTime dueDate;
  final AmountValue previousBillAmount;
  final AmountValue currentBillAmount;
  final AmountValue outstandingAmount;
  final num spentAmount;
  final AmountValue accumulatedInterestAmount;
  final num interestRate;
  final AmountValue fixedRate;
  final AccountData referenceAccount;

  const CreditLine({
    required this.id,
    required this.dueDate,
    required this.previousBillAmount,
    required this.currentBillAmount,
    required this.outstandingAmount,
    required this.spentAmount,
    required this.accumulatedInterestAmount,
    required this.interestRate,
    required this.fixedRate,
    required this.referenceAccount,
  });

  factory CreditLine.fromJson(Map<String, dynamic> json) => CreditLine(
        id: json['application_id'],
        dueDate: DateTime.parse(json['due_date']),
        previousBillAmount: AmountValue.fromJson(json['previous_bill_amount']),
        currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
        outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
        spentAmount: json['amount_spent'],
        accumulatedInterestAmount: AmountValue.fromJson(json['accumulated_interest_amount']),
        interestRate: json['interest_rate'],
        fixedRate: AmountValue.fromJson(json['fixed_repayment_rate']),
        referenceAccount: AccountData.fromJson(json['reference_account']),
      );

  factory CreditLine.empty() => CreditLine(
        id: '0',
        dueDate: DateTime.now(),
        previousBillAmount: AmountValue.empty(),
        currentBillAmount: AmountValue.empty(),
        outstandingAmount: AmountValue.empty(),
        spentAmount: 0.0,
        accumulatedInterestAmount: AmountValue.empty(),
        interestRate: 0.0,
        fixedRate: AmountValue.empty(),
        referenceAccount: AccountData.empty(),
      );
}
