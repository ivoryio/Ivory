// To parse this JSON data, do
//
//     final debitCard = debitCardFromJson(jsonString);

import 'dart:convert';

class DebitCard {
  DebitCard({
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
  final DebitCardRepresentation? representation;

  factory DebitCard.fromRawJson(String str) =>
      DebitCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DebitCard.fromJson(Map<String, dynamic> json) => DebitCard(
        id: json["id"],
        accountId: json["account_id"],
        status: json["status"],
        type: json["type"],
        representation: json["representation"] == null
            ? null
            : DebitCardRepresentation.fromJson(json["representation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "status": status,
        "type": type,
        "representation": representation?.toJson(),
      };
}

class DebitCardRepresentation {
  DebitCardRepresentation({
    this.line1,
    this.maskedPan,
    this.formattedExpirationDate,
  });

  final String? line1;
  final String? maskedPan;
  final String? formattedExpirationDate;

  factory DebitCardRepresentation.fromRawJson(String str) =>
      DebitCardRepresentation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DebitCardRepresentation.fromJson(Map<String, dynamic> json) =>
      DebitCardRepresentation(
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
