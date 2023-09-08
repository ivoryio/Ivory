// ignore_for_file: constant_identifier_names

import 'dart:convert';

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
        accountId: json["account_id"],
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

String createCardToJson(CreateBankCard data) => json.encode(data.toJson());

class CreateBankCard {
  late String line1;
  late String line2;
  BankCardType type;
  String businessId;
  late String reference;

  CreateBankCard(
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

class Jwe {
  String alg;
  String enc;

  Jwe({
    required this.alg,
    required this.enc,
  });
  factory Jwe.defaultValues() {
    return Jwe(
      alg: _defaultJWKalg,
      enc: _defaultJWEenc,
    );
  }
  Map<String, dynamic> toJson() => {
        "alg": alg,
        "enc": enc,
      };
}

class Jwk {
  String kty = _defaultJWKkty;
  // String use = _defaultJWKuse;
  // String alg = _defaultJWKalg;
  String n;
  String e;

  Jwk({
    required this.n,
    required this.e,
  });

  Map<String, dynamic> toJson() => {
        "kty": kty,
        // "use": use,
        // "alg": alg,
        "n": n,
        "e": e,
      };
 
  String toAlphabeticJson() {
    Map<String, dynamic> jwkMap = {
      'kty': kty,
      'n': n,
      'e': e,
      // 'use': use,
      // 'alg': alg,
    };

    var sortedMap = Map.fromEntries(jwkMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    var jsonString = jsonEncode(sortedMap);

    // Remove whitespace characters from the JSON string
    var compactJsonString = jsonString.replaceAll(RegExp(r'\s+'), '');

    return compactJsonString;
  }
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

//default values for jwk and jwe
String _defaultJWKalg = "RS256";
String _defaultJWKuse = "enc";
String _defaultJWKkty = "RSA";

String _defaultJWEalg = "RSA1_5";
String _defaultJWEenc = "A256GCM";
