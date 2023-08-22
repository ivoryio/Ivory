import 'package:solarisdemo/models/amount_value.dart';

class Bill {
  final String id;
  final String postboxItemId;

  final DateTime statementDate;
  final DateTime dueDate;

  final AmountValue prevBillAmount;
  final AmountValue currentBillAmount;
  final AmountValue totalOutstandingAmount;
  final AmountValue outstandingAmount;

  const Bill({
    required this.id,
    required this.postboxItemId,
    required this.statementDate,
    required this.dueDate,
    required this.prevBillAmount,
    required this.currentBillAmount,
    required this.totalOutstandingAmount,
    required this.outstandingAmount,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      postboxItemId: json['postbox_item_id'],
      statementDate: DateTime.parse(json['statement_date']),
      dueDate: DateTime.parse(json['due_date']),
      prevBillAmount: AmountValue.fromJson(json['previous_bill_amount']),
      currentBillAmount: AmountValue.fromJson(json['current_bill_amount']),
      totalOutstandingAmount: AmountValue.fromJson(json['total_outstanding_amount']),
      outstandingAmount: AmountValue.fromJson(json['outstanding_amount']),
    );
  }
}
