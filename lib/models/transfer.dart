// ignore_for_file: constant_identifier_names

import 'dart:convert';

enum TransferType {
  SEPA_CREDIT_TRANSFER,
  UNKNOWN,
}

class Transfer {
  Transfer({
    required this.type,
    required this.reference,
    required this.description,
    required this.recipientBic,
    required this.endToEndId,
    required this.recipientName,
    required this.recipientIban,
    required this.amount,
  });

  final TransferType type;
  final String reference;
  final String description;
  final String recipientBic;
  final String endToEndId;
  final String recipientName;
  final String recipientIban;
  final AmountTransfer amount;

  factory Transfer.fromRawJson(String str) =>
      Transfer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transfer.fromJson(Map<String, dynamic> json) => Transfer(
        type: getTransferType(json["type"]),
        reference: json["reference"],
        description: json["description"],
        recipientBic: json["recipient_bic"],
        endToEndId: json["end_to_end_id"],
        recipientName: json["recipient_name"],
        recipientIban: json["recipient_iban"],
        amount: AmountTransfer.fromJson(json["amount"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type.name,
        "reference": reference,
        "description": description,
        "recipient_bic": recipientBic,
        "end_to_end_id": endToEndId,
        "recipient_name": recipientName,
        "recipient_iban": recipientIban,
        "amount": amount.toJson(),
      };
}

class AmountTransfer {
  AmountTransfer({
    required this.value,
    required this.currency,
  });

  final num value;
  final String currency;

  factory AmountTransfer.fromRawJson(String str) =>
      AmountTransfer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmountTransfer.fromJson(Map<String, dynamic> json) => AmountTransfer(
        value: json["value"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "currency": currency,
      };
}

TransferType getTransferType(String type) {
  switch (type) {
    case 'SEPA_CREDIT_TRANSFER':
      return TransferType.SEPA_CREDIT_TRANSFER;
    default:
      return TransferType.UNKNOWN;
  }
}
