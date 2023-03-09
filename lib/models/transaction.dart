class Transaction {
  String? id;
  String? bookingType;
  Amount? amount;
  String? description;
  String? endToEndId;
  String? recipientBic;
  String? recipientIban;
  String? recipientName;
  String? reference;
  String? bookingDate;
  String? valutaDate;
  String? metaInfo;

  Transaction(
      {this.id,
      this.bookingType,
      this.amount,
      this.description,
      this.endToEndId,
      this.recipientBic,
      this.recipientIban,
      this.recipientName,
      this.reference,
      this.bookingDate,
      this.valutaDate,
      this.metaInfo});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingType = json['booking_type'];
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    description = json['description'];
    endToEndId = json['end_to_end_id'];
    recipientBic = json['recipient_bic'];
    recipientIban = json['recipient_iban'];
    recipientName = json['recipient_name'];
    reference = json['reference'];
    bookingDate = json['booking_date'];
    valutaDate = json['valuta_date'];
    metaInfo = json['meta_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['booking_type'] = bookingType;
    if (amount != null) {
      data['amount'] = amount!.toJson();
    }
    data['description'] = description;
    data['end_to_end_id'] = endToEndId;
    data['recipient_bic'] = recipientBic;
    data['recipient_iban'] = recipientIban;
    data['recipient_name'] = recipientName;
    data['reference'] = reference;
    data['booking_date'] = bookingDate;
    data['valuta_date'] = valutaDate;
    data['meta_info'] = metaInfo;
    return data;
  }
}

class Amount {
  double? value;
  String? unit;
  String? currency;

  Amount({this.value, this.unit, this.currency});

  Amount.fromJson(Map<String, dynamic> json) {
    value = json['value'] != null ? json['value'].toDouble() : 0;
    unit = json['unit'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['unit'] = unit;
    data['currency'] = currency;
    return data;
  }
}
