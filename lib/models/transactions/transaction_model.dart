import 'package:solarisdemo/utilities/format.dart';

import '../amount_value.dart';
import '../categories/category.dart';

class Transaction {
  String? id;
  String? bookingType;
  AmountValue? amount;
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
  Category? category;

  Transaction({
    this.id,
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
    this.senderName,
    this.category,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingType = json['booking_type'];
    amount = json['amount'] != null ? AmountValue.fromJson(json['amount']) : null;
    description = json['description'];
    endToEndId = json['end_to_end_id'] ?? "ID";
    recipientBic = json['recipient_bic'];
    recipientIban = json['recipient_iban'];
    recipientName = processRecipient(json['recipient_name']);
    reference = json['reference'];
    bookingDate = json['booking_date'];
    valutaDate = json['valuta_date'];
    metaInfo = json['meta_info'];
    recordedAt = DateTime.parse(json['recorded_at']).toLocal();
    senderIban = json['sender_iban'];
    senderName = json['sender_name'] ?? "Bank account";
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
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
    data['category'] = category;

    return data;
  }

  String processRecipient(String? recipientName) {
    if (recipientName == null) {
      return "E-car";
    }

    if (recipientName.toLowerCase().contains("solaris")) {
      return "E-car";
    }

    return recipientName;
  }
}

class TransactionListFilter {
  final DateTime? bookingDateMin;
  final DateTime? bookingDateMax;
  final String? searchString;
  final int? page;
  final int? size;
  final String? sort;
  final List<Category>? categories;

  const TransactionListFilter({
    this.bookingDateMin,
    this.bookingDateMax,
    this.searchString,
    this.page,
    this.size,
    this.sort,
    this.categories,
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

    if (searchString != null) {
      map["filter[description]"] = searchString!;
    }

    if (categories != null) {
      if (categories!.isNotEmpty) {
        List<String> categoryIds = categories!.map((category) => category.id).toList();
        map["filter[category_id]"] = '[${categoryIds.join(",")}]';
      }
    }

    return map;
  }
}
