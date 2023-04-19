// To parse this JSON data, do
//
//     final creditCard = creditCardFromJson(jsonString);

import 'dart:convert';

class CreditCard {
  CreditCard({
    this.id,
    this.accountId,
    this.status,
    this.type,
    this.representation,
  });

  final String? id;
  final String? accountId;
  final String? status;
  final String? type;
  final CreditCardRepresentation? representation;

  factory CreditCard.fromRawJson(String str) =>
      CreditCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditCard.fromJson(Map<String, dynamic> json) => CreditCard(
        id: json["id"],
        accountId: json["account_id"],
        status: json["status"],
        type: json["type"],
        representation: json["representation"] == null
            ? null
            : CreditCardRepresentation.fromJson(json["representation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "status": status,
        "type": type,
        "representation": representation?.toJson(),
      };
}

class CreditCardRepresentation {
  CreditCardRepresentation({
    this.line1,
    this.maskedPan,
    this.formattedExpirationDate,
  });

  final String? line1;
  final String? maskedPan;
  final String? formattedExpirationDate;

  factory CreditCardRepresentation.fromRawJson(String str) =>
      CreditCardRepresentation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditCardRepresentation.fromJson(Map<String, dynamic> json) =>
      CreditCardRepresentation(
        line1: json["line_1"],
        maskedPan: json["masked_pan"],
        formattedExpirationDate: json["formatted_expiration_date"],
      );

  Map<String, dynamic> toJson() => {
        "line_1": line1,
        "masked_pan": maskedPan,
        "formatted_expiration_date": formattedExpirationDate,
      };
}
