import 'package:solarisdemo/models/amount_value.dart';

class Bill {
  final String id;
  final String postboxItemId;

  final DateTime statementDate;
  final DateTime dueDate;

  final AmountValue? amountSpent;
  final AmountValue currentBillAmount;
  final AmountValue totalOutstandingAmount;
  final AmountValue outstandingAmount;

  final num interestRate;

  final List<BillTransaction>? transactions;

  const Bill({
    required this.id,
    required this.postboxItemId,
    required this.statementDate,
    required this.dueDate,
    required this.amountSpent,
    required this.currentBillAmount,
    required this.totalOutstandingAmount,
    required this.outstandingAmount,
    required this.interestRate,
    required this.transactions,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      postboxItemId: json['postbox_item_id'] ?? "",
      statementDate: DateTime.parse(json['statement_date']),
      dueDate: DateTime.parse(json['due_date']),
      amountSpent:
          json['amount_spent'] != null ? AmountValue.fromJson(json['amount_spent']) : AmountValue.empty(), // TODO: null
      currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
      totalOutstandingAmount: AmountValue.fromJson(json['total_outstanding_amount']),
      outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
      interestRate: json['interest_rate'] ?? 15, // TODO: null
      transactions: ((json['transactions']) as List?)?.map((e) => BillTransaction.fromJson(e)).toList(),
    );
  }
}

class BillTransaction {
  final String merchantName;
  final AmountValue amount;

  const BillTransaction({
    required this.merchantName,
    required this.amount,
  });

  factory BillTransaction.fromJson(Map<String, dynamic> json) {
    return BillTransaction(
      merchantName: json['merchant_name'],
      amount: AmountValue.fromJson(json['amount']),
    );
  }
}
