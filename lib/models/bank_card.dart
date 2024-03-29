// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:solarisdemo/models/crypto/jwe.dart';
import 'package:solarisdemo/models/crypto/jwk.dart';
import 'package:uuid/uuid.dart';

enum BankCardStatus {
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

// TODO These card types are from Solaris Documentation. For future use
// enum CardType {
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

enum BankCardType {
  VIRTUAL_VISA_BUSINESS_DEBIT,
  VISA_BUSINESS_DEBIT,
  VISA_BUSINESS_DEBIT_2,
  MASTERCARD_BUSINESS_DEBIT,
  VIRTUAL_MASTERCARD_BUSINESS_DEBIT,
  VIRTUAL_VISA_FREELANCE_DEBIT,
  VIRTUAL_VISA_CREDIT,
  VISA_CREDIT,
  VISA_DEBIT,
}

class BankCard {
  BankCard({
    required this.id,
    required this.accountId,
    required this.status,
    required this.type,
    this.representation,
  });

  final String id;
  final String accountId;
  final BankCardStatus status;
  final BankCardType type;
  final BankCardRepresentation? representation;

  factory BankCard.fromRawJson(String str) =>
      BankCard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankCard.fromJson(Map<String, dynamic> json) => BankCard(
        id: json["id"],
        accountId: json["account_id"] ?? '',
        status: getCardStatus(json["status"] ?? BankCardStatus.INACTIVE.name),
        type:
            getCardType(json["type"] ?? BankCardType.VIRTUAL_VISA_CREDIT.name),
        representation: json["representation"] == null
            ? null
            : BankCardRepresentation.fromJson(json["representation"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_id": accountId,
        "status": status.name,
        "type": type.name,
        "representation": representation?.toJson(),
      };
}

BankCardType getCardType(String type) {
  switch (type) {
    case 'VIRTUAL_VISA_BUSINESS_DEBIT':
      return BankCardType.VIRTUAL_VISA_BUSINESS_DEBIT;
    case 'VISA_BUSINESS_DEBIT':
      return BankCardType.VISA_BUSINESS_DEBIT;
    case 'VISA_BUSINESS_DEBIT_2':
      return BankCardType.VISA_BUSINESS_DEBIT_2;
    case 'MASTERCARD_BUSINESS_DEBIT':
      return BankCardType.MASTERCARD_BUSINESS_DEBIT;
    case 'VIRTUAL_MASTERCARD_BUSINESS_DEBIT':
      return BankCardType.VIRTUAL_MASTERCARD_BUSINESS_DEBIT;
    case 'VIRTUAL_VISA_FREELANCE_DEBIT':
      return BankCardType.VIRTUAL_VISA_FREELANCE_DEBIT;
    case 'VIRTUAL_VISA_CREDIT':
      return BankCardType.VIRTUAL_VISA_CREDIT;
    case 'VISA_CREDIT':
      return BankCardType.VISA_CREDIT;
    case 'VISA_DEBIT':
      return BankCardType.VISA_DEBIT;
    case 'VISA_CREDIT01':
      return BankCardType.VIRTUAL_VISA_CREDIT;
    default:
      throw Exception('Unknown CardType: $type');
  }
}

BankCardStatus getCardStatus(String status) {
  switch (status) {
    case 'ACTIVE':
      return BankCardStatus.ACTIVE;
    case 'ACTIVATION_BLOCKED_BY_SOLARIS':
      return BankCardStatus.ACTIVATION_BLOCKED_BY_SOLARIS;
    case 'BLOCKED':
      return BankCardStatus.BLOCKED;
    case 'BLOCKED_BY_SOLARIS':
      return BankCardStatus.BLOCKED_BY_SOLARIS;
    case 'CLOSED':
      return BankCardStatus.CLOSED;
    case 'CLOSED_BY_SOLARIS':
      return BankCardStatus.CLOSED_BY_SOLARIS;
    case 'COUNTERFEIT_CARD':
      return BankCardStatus.COUNTERFEIT_CARD;
    case 'FRAUD':
      return BankCardStatus.FRAUD;
    case 'INACTIVE':
      return BankCardStatus.INACTIVE;
    case 'LOST':
      return BankCardStatus.LOST;
    case 'NEVER_RECEIVED':
      return BankCardStatus.NEVER_RECEIVED;
    case 'PROCESSING':
      return BankCardStatus.PROCESSING;
    case 'STOLEN':
      return BankCardStatus.STOLEN;
    default:
      return BankCardStatus.INACTIVE;
  }
}

class BankCardRepresentation {
  BankCardRepresentation({
    this.line1,
    this.line2,
    this.maskedPan,
    this.formattedExpirationDate,
  });

  final String? line1;
  final String? line2;
  final String? maskedPan;
  final String? formattedExpirationDate;

  factory BankCardRepresentation.fromRawJson(String str) =>
      BankCardRepresentation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BankCardRepresentation.fromJson(Map<String, dynamic> json) =>
      BankCardRepresentation(
        line1: json["line_1"],
        line2: json["line_2"],
        maskedPan: json["masked_pan"],
        formattedExpirationDate: json["formatted_expiration_date"],
      );

  Map<String, dynamic> toJson() => {
        "line_1": line1,
        "line_2": line2,
        "masked_pan": maskedPan,
        "formatted_expiration_date": formattedExpirationDate,
      };
}

class BankCardFetchedDetails {
  final String cardNumber;
  final String cardExpiry;
  final String cvv;
  final String cardHolder;

  BankCardFetchedDetails({
    required this.cardNumber,
    required this.cardExpiry,
    required this.cvv,
    required this.cardHolder,
  });
}

String createCardToJson(CreateBankCardReqBody data) => json.encode(data.toJson());

class CreateBankCardReqBody {
  late String line1;
  late String line2;
  BankCardType type;
  String businessId;
  late String reference;

  CreateBankCardReqBody(
    String firstName,
    String lastName,
    this.type,
    this.businessId,
  ) {
    if (firstName.length > 21) {
      firstName = firstName.substring(0, 21);
    }
    line1 = firstName.toUpperCase(); // TODO
    line2 = firstName.toUpperCase();
    reference = const Uuid().v4().replaceAll('-', '');
  }

  Map<String, dynamic> toJson() => {
        "line_1": line1,
        "line_2": line2,
        "type": type.name,
        "business_id": businessId,
        "reference": reference,
      };
}

String getCardDetailsRequestToJson(GetCardDetailsRequestBody data) =>
    json.encode(data.toJson());

class GetCardDetailsRequestBody {
  String deviceId;
  String deviceData;
  String signature;
  Jwk jwk;
  Jwe jwe;

  GetCardDetailsRequestBody({
    required this.deviceId,
    required this.deviceData,
    required this.signature,
    required this.jwk,
    required this.jwe,
  });

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "device_data": deviceData,
        "signature": signature,
        "jwk": jwk.toJson(),
        "jwe": jwe.toJson(),
      };
}

GetCardDetailsResponse getCardDetailsResponseFromJson(String str) =>
    GetCardDetailsResponse.fromJson(json.decode(str));

class GetCardDetailsResponse {
  String data;

  GetCardDetailsResponse({
    required this.data,
  });

  factory GetCardDetailsResponse.fromJson(Map<String, dynamic> json) =>
      GetCardDetailsResponse(
        data: json["data"],
      );
}

String changePinRequestBodyToJson(ChangePinRequestBody data) => json.encode(data.toJson());

class ChangePinRequestBody {
    String encryptedPin;
    String keyId;
    String deviceId;
    String deviceData;
    String signature;

    ChangePinRequestBody({
        required this.encryptedPin,
        required this.keyId,
        required this.deviceId,
        required this.deviceData,
        required this.signature,
    });

    Map<String, dynamic> toJson() => {
        "encrypted_pin": encryptedPin,
        "key_id": keyId,
        "device_id": deviceId,
        "device_data": deviceData,
        "signature": signature,
    };
}
