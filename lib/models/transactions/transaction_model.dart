import 'package:solarisdemo/utilities/format.dart';

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
  DateTime? recordedAt;
  String? senderIban;
  String? senderName;

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
      this.metaInfo,
      this.recordedAt,
      this.senderIban,
      this.senderName});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingType = json['booking_type'];
    amount = json['amount'] != null ? Amount.fromJson(json['amount']) : null;
    description = json['description'];
    endToEndId = json['end_to_end_id'] ?? "ID";
    recipientBic = json['recipient_bic'];
    recipientIban = json['recipient_iban'];
    recipientName = json['recipient_name'] ?? "SOLARIS";
    reference = json['reference'];
    bookingDate = json['booking_date'];
    valutaDate = json['valuta_date'];
    metaInfo = json['meta_info'];
    recordedAt = DateTime.parse(json['recorded_at']);
    senderIban = json['sender_iban'];
    senderName = json['sender_name'] ?? "SOLARIS";
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
    data['recorded_at'] = recordedAt!.toIso8601String();
    data['sender_iban'] = senderIban;
    data['sender_name'] = senderName;
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

class TransactionListFilter {
  final DateTime? bookingDateMin;
  final DateTime? bookingDateMax;
  final String? searchString;
  final int? page;
  final int? size;
  final String? sort;
  final List<String>? categoryIds;

  const TransactionListFilter({
    this.bookingDateMin,
    this.bookingDateMax,
    this.searchString,
    this.page,
    this.size,
    this.sort,
    this.categoryIds,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (bookingDateMin != null) {
      map["filter[booking_date][min]"] = Format.date(bookingDateMin!);
    }

    if (bookingDateMax != null) {
      map["filter[booking_date][max]"] = Format.date(bookingDateMax!);
    }

    if (page != null) {
      map["page[number]"] = page.toString();
    }

    if (size != null) {
      map["page[size]"] = size.toString();
    }

    if (sort != null) {
      map["sort"] = sort!;
    }

    if(searchString != null) {
      map["filter[description]"] = searchString!;
    }

    if(categoryIds != null) {
      for (int index = 0; index < categoryIds!.length; index++) {
        map["filter[category_id]"] = categoryIds![index];
      }
    }

    return map;
  }
}