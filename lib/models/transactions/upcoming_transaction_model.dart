import '../amount_value.dart';

class UpcomingTransaction {
  String? id;
  String? applicationId;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? statementDate;
  DateTime? dueDate;
  DateTime? sddCollectionDate;
  AmountValue? previousBillAmount;
  AmountValue? currentBillAmount;
  AmountValue? totalOutstandingAmount;
  AmountValue? minimumDueAmount;
  AmountValue? outstandingSddrAmount;
  AmountValue? outstandingAmount;
  String? repaymentType;
  AmountValue? minimumAmount;
  int? minimumPercentage;
  int? gracePeriodInDays;
  AmountValue? dunningFees;
  AmountValue? otherFees;
  AmountValue? accumulatedInterestAmount;
  String? postboxItemId;

  UpcomingTransaction({
    this.id,
    this.applicationId,
    this.status,
    this.startDate,
    this.endDate,
    this.statementDate,
    this.dueDate,
    this.sddCollectionDate,
    this.previousBillAmount,
    this.currentBillAmount,
    this.totalOutstandingAmount,
    this.minimumDueAmount,
    this.outstandingSddrAmount,
    this.outstandingAmount,
    this.repaymentType,
    this.minimumAmount,
    this.minimumPercentage,
    this.gracePeriodInDays,
    this.dunningFees,
    this.otherFees,
    this.accumulatedInterestAmount,
    this.postboxItemId,
  });

  UpcomingTransaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    applicationId = json['application_id'];
    status = json['status'];
    startDate = DateTime.parse(json['start_date']);
    endDate = DateTime.parse(json['end_date']);
    statementDate = DateTime.parse(json['statement_date']);
    dueDate = DateTime.parse(json['due_date']);
    sddCollectionDate = DateTime.parse(json['sdd_collection_date']);
    previousBillAmount =
        json['previous_bill_amount'] != null ? AmountValue.fromJson(json['previous_bill_amount']) : null;
    currentBillAmount = json['current_bill_amount'] != null ? AmountValue.fromJson(json['current_bill_amount']) : null;
    totalOutstandingAmount =
        json['total_outstanding_amount'] != null ? AmountValue.fromJson(json['total_outstanding_amount']) : null;
    minimumDueAmount = json['minimum_due_amount'] != null ? AmountValue.fromJson(json['minimum_due_amount']) : null;
    outstandingSddrAmount =
        json['outstanding_sddr_amount'] != null ? AmountValue.fromJson(json['outstanding_sddr_amount']) : null;
    outstandingAmount = json['outstanding_amount'] != null ? AmountValue.fromJson(json['outstanding_amount']) : null;
    repaymentType = json['repayment_type'];
    minimumAmount = json['minimum_amount'] != null ? AmountValue.fromJson(json['minimum_amount']) : null;
    minimumPercentage = json['minimum_percentage'];
    gracePeriodInDays = json['grace_period_in_days'];
    dunningFees = json['dunning_fees'] != null ? AmountValue.fromJson(json['dunning_fees']) : null;
    otherFees = json['other_fees'] != null ? AmountValue.fromJson(json['other_fees']) : null;
    accumulatedInterestAmount =
        json['accumulated_interest_amount'] != null ? AmountValue.fromJson(json['accumulated_interest_amount']) : null;
    postboxItemId = json['postbox_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['application_id'] = applicationId;
    data['status'] = status;
    data['start_date'] = startDate!.toIso8601String();
    data['end_date'] = endDate!.toIso8601String();
    data['statement_date'] = statementDate!.toIso8601String();
    data['due_date'] = dueDate!.toIso8601String();
    data['sdd_collection_date'] = sddCollectionDate!.toIso8601String();
    if (data['previous_bill_amount'] == null) {
      data['previous_bill_amount'] = previousBillAmount!.toJson();
    }
    if (data['current_bill_amount'] == null) {
      data['current_bill_amount'] = currentBillAmount!.toJson();
    }
    if (data['total_outstanding_amount'] == null) {
      data['total_outstanding_amount'] = totalOutstandingAmount!.toJson();
    }
    if (data['minimum_due_amount'] == null) {
      data['minimum_due_amount'] = minimumDueAmount!.toJson();
    }
    if (data['outstanding_sddr_amount'] == null) {
      data['outstanding_sddr_amount'] = outstandingSddrAmount!.toJson();
    }
    if (data['outstanding_amount'] == null) {
      data['outstanding_amount'] = outstandingAmount!.toJson();
    }
    data['repayment_type'] = repaymentType;
    if (data['minimum_amount'] == null) {
      data['minimum_amount'] = minimumAmount!.toJson();
    }
    data['minimum_percentage'] = minimumPercentage;
    data['grace_period_in_days'] = gracePeriodInDays;
    if (data['dunning_fees'] == null) {
      data['dunning_fees'] = dunningFees!.toJson();
    }
    if (data['other_fees'] == null) {
      data['other_fees'] = otherFees!.toJson();
    }
    if (data['accumulated_interest_amount'] == null) {
      data['accumulated_interest_amount'] = accumulatedInterestAmount!.toJson();
    }
    data['postbox_item_id'] = postboxItemId;

    return data;
  }
}
