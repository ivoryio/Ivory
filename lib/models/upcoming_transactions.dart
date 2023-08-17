class UpcomingTransactions {
  String? id;
  String? application_id;
  String? status;
  DateTime? start_date;
  DateTime? end_date;
  DateTime? statement_date;
  DateTime? due_date;
  DateTime? sdd_collection_date;
  CardBillAmount? previous_bill_amount;
  CardBillAmount? current_bill_amount;
  CardBillAmount? total_outstanding_amount;
  CardBillAmount? minimum_due_amount;
  CardBillAmount? outstanding_sddr_amount;
  CardBillAmount? outstanding_amount;
  String? repayment_type;
  CardBillAmount? minimum_amount;
  double? minimum_percentage;
  int? grace_period_in_days;
  CardBillAmount? dunning_fees;
  CardBillAmount? other_fees;
  CardBillAmount? accumulated_interest_amount;
  String? postbox_item_id;

  UpcomingTransactions({
    this.id,
    this.application_id,
    this.status,
    this.start_date,
    this.end_date,
    this.statement_date,
    this.due_date,
    this.sdd_collection_date,
    this.previous_bill_amount,
    this.current_bill_amount,
    this.total_outstanding_amount,
    this.minimum_due_amount,
    this.outstanding_sddr_amount,
    this.outstanding_amount,
    this.repayment_type,
    this.minimum_amount,
    this.minimum_percentage,
    this.grace_period_in_days,
    this.dunning_fees,
    this.other_fees,
    this.accumulated_interest_amount,
    this.postbox_item_id,
  });

  UpcomingTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    application_id = json['application_id'];
    status = json['status'];
    start_date = DateTime.parse(json['start_date']);
    end_date = DateTime.parse(json['end_date']);
    statement_date = DateTime.parse(json['statement_date']);
    due_date = DateTime.parse(json['due_date']);
    sdd_collection_date = DateTime.parse(json['sdd_collection_date']);
    previous_bill_amount = json['previous_bill_amount'] != null
        ? CardBillAmount.fromJson(json['previous_bill_amount'])
        : null;
    current_bill_amount = json['current_bill_amount'] != null
        ? CardBillAmount.fromJson(json['current_bill_amount'])
        : null;
    total_outstanding_amount = json['total_outstanding_amount'] != null
        ? CardBillAmount.fromJson(json['total_outstanding_amount'])
        : null;
    minimum_due_amount = json['minimum_due_amount'] != null
        ? CardBillAmount.fromJson(json['minimum_due_amount'])
        : null;
    outstanding_sddr_amount = json['outstanding_sddr_amount'] != null
        ? CardBillAmount.fromJson(json['outstanding_sddr_amount'])
        : null;
    outstanding_amount = json['outstanding_amount'] != null
        ? CardBillAmount.fromJson(json['outstanding_amount'])
        : null;
    repayment_type = json['repayment_type'];
    minimum_amount = json['minimum_amount'] != null
        ? CardBillAmount.fromJson(json['minimum_amount'])
        : null;
    minimum_percentage = json['minimum_percentage'];
    grace_period_in_days = json['grace_period_in_days'];
    dunning_fees = json['dunning_fees'] != null
        ? CardBillAmount.fromJson(json['dunning_fees'])
        : null;
    other_fees = json['other_fees'] != null
        ? CardBillAmount.fromJson(json['other_fees'])
        : null;
    accumulated_interest_amount = json['accumulated_interest_amount'] != null
        ? CardBillAmount.fromJson(json['accumulated_interest_amount'])
        : null;
    postbox_item_id = json['postbox_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['application_id'] = application_id;
    data['status'] = status;
    data['start_date'] = start_date;
    data['end_date'] = end_date;
    data['statement_date'] = statement_date;
    data['due_date'] = due_date;
    data['sdd_collection_date'] = sdd_collection_date;
    data['previous_bill_amount'] = previous_bill_amount;
    data['current_bill_amount'] = current_bill_amount;
    data['total_outstanding_amount'] = total_outstanding_amount;
    data['minimum_due_amount'] = minimum_due_amount;
    data['outstanding_sddr_amount'] = outstanding_sddr_amount;
    data['outstanding_amount'] = outstanding_amount;
    data['repayment_type'] = repayment_type;
    data['minimum_amount'] = minimum_amount;
    data['minimum_percentage'] = minimum_percentage;
    data['grace_period_in_days'] = grace_period_in_days;
    data['dunning_fees'] = dunning_fees;
    data['other_fees'] = other_fees;
    data['accumulated_interest_amount'] = accumulated_interest_amount;
    data['postbox_item_id'] = postbox_item_id;

    return data;
  }
}

class CardBillAmount {
  String? unit;
  double? value;
  String? currency;

  CardBillAmount({
    this.unit,
    this.value,
    this.currency,
  });

  CardBillAmount.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    value = json['value'] != null ? json['value'].toDouble() : 0;
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['unit'] = unit;
    data['value'] = value;
    data['currency'] = currency;

    return data;
  }
}
