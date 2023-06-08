// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:uuid/uuid.dart';

enum DebitCardStatus {
  ACTIVE,
  ACTIVATION_BLOCKED_BY_SOLARIS,
  BLOCKED,
  BLOCKED_BY_SOLARIS,
  CLOSED,
  CLOSED_BY_SOLARIS,
  COUNTERFEIT_CARD,
  FRAUD,
  INACTIVE,
  LOST,
  NEVER_RECEIVED,
  PROCESSING,
  STOLEN
}

//These card types are from Solaris Documentation. For future use
// enum DebitCardType {
//   MASTERCARD_DEBIT,
//   MASTERCARD_BUSINESS_DEBIT,
//   VIRTUAL_MASTERCARD_DEBIT,
//   VIRTUAL_MASTERCARD_BUSINESS_DEBIT,
//   VIRTUAL_MASTERCARD_FREELANCE_DEBIT,
//   VISA_DEBIT,
//   VISA_BUSINESS_DEBIT,
//   VIRTUAL_VISA_DEBIT,
//   VIRTUAL_VISA_BUSINESS_DEBIT,
//   VIRTUAL_VISA_FREELANCE_DEBIT
// }

enum DebitCardType {
  VIRTUAL_VISA_BUSINESS_DEBIT,
  VISA_BUSINESS_DEBIT,
  VISA_BUSINESS_DEBIT_2,
  MASTERCARD_BUSINESS_DEBIT,
  VIRTUAL_MASTERCARD_BUSINESS_DEBIT,
  VIRTUAL_VISA_FREELANCE_DEBIT,
}

class DebitCard {
  DebitCard({
    required this.id,
    required this.accountId,
    required this.status,
    required this.type,
    this.representation,
  });

  final String id;
  final String accountId;
  final DebitCardStatus status;
  final DebitCardType type;
  final DebitCardRepresentation? representation;

  factory DebitCard.fromRawJson(String str) =>
      DebitCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DebitCard.fromJson(Map<String, dynamic> json) => DebitCard(
        id: json["id"],
        accountId: json["account_id"],
        status: getDebitCardStatus(json["status"]),
        type: getDebitCardType(json["type"]),
        representation: json["representation"] == null
            ? null
            : DebitCardRepresentation.fromJson(json["representation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "status": status.name,
        "type": type.name,
        "representation": representation?.toJson(),
      };
}

DebitCardType getDebitCardType(String type) {
  switch (type) {
    case 'VIRTUAL_VISA_BUSINESS_DEBIT':
      return DebitCardType.VIRTUAL_VISA_BUSINESS_DEBIT;
    case 'VISA_BUSINESS_DEBIT':
      return DebitCardType.VISA_BUSINESS_DEBIT;
    case 'VISA_BUSINESS_DEBIT_2':
      return DebitCardType.VISA_BUSINESS_DEBIT_2;
    case 'MASTERCARD_BUSINESS_DEBIT':
      return DebitCardType.MASTERCARD_BUSINESS_DEBIT;
    case 'VIRTUAL_MASTERCARD_BUSINESS_DEBIT':
      return DebitCardType.VIRTUAL_MASTERCARD_BUSINESS_DEBIT;
    case 'VIRTUAL_VISA_FREELANCE_DEBIT':
      return DebitCardType.VIRTUAL_VISA_FREELANCE_DEBIT;
    default:
      throw Exception('Unknown DebitCardType: $type');
  }
}

DebitCardStatus getDebitCardStatus(String status) {
  switch (status) {
    case 'ACTIVE':
      return DebitCardStatus.ACTIVE;
    case 'ACTIVATION_BLOCKED_BY_SOLARIS':
      return DebitCardStatus.ACTIVATION_BLOCKED_BY_SOLARIS;
    case 'BLOCKED':
      return DebitCardStatus.BLOCKED;
    case 'BLOCKED_BY_SOLARIS':
      return DebitCardStatus.BLOCKED_BY_SOLARIS;
    case 'CLOSED':
      return DebitCardStatus.CLOSED;
    case 'CLOSED_BY_SOLARIS':
      return DebitCardStatus.CLOSED_BY_SOLARIS;
    case 'COUNTERFEIT_CARD':
      return DebitCardStatus.COUNTERFEIT_CARD;
    case 'FRAUD':
      return DebitCardStatus.FRAUD;
    case 'INACTIVE':
      return DebitCardStatus.INACTIVE;
    case 'LOST':
      return DebitCardStatus.LOST;
    case 'NEVER_RECEIVED':
      return DebitCardStatus.NEVER_RECEIVED;
    case 'PROCESSING':
      return DebitCardStatus.PROCESSING;
    case 'STOLEN':
      return DebitCardStatus.STOLEN;
    default:
      return DebitCardStatus.INACTIVE;
  }
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

String createDebitCardToJson(CreateDebitCard data) =>
    json.encode(data.toJson());

class CreateDebitCard {
  late String line1;
  DebitCardType type;
  String businessId;
  late String reference;

  CreateDebitCard(
    String firstName,
    String lastName,
    this.type,
    this.businessId,
  ) {
    line1 = '$firstName/$lastName'.toUpperCase();
    reference = const Uuid().v4().replaceAll('-', '');
  }

  Map<String, dynamic> toJson() => {
        "line_1": line1,
        "type": type.name,
        "business_id": businessId,
        "reference": reference,
      };
}
