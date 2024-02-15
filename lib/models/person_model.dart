import 'dart:convert';

class Person {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String title;
  final String city;
  final String country;
  final PersonAddress address;
  final String birthCity;
  final String birthCountry;
  final DateTime birthDate;
  final String mobileNumber;
  final String nationality;
  final String occupation;

  const Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.title,
    required this.city,
    required this.country,
    required this.address,
    required this.birthCity,
    required this.birthCountry,
    required this.birthDate,
    required this.mobileNumber,
    required this.nationality,
    required this.occupation,
  });
}

class PersonAddress {
  final String line1;
  final String line2;
  final String postalCode;
  final String city;
  final String country;

  const PersonAddress({
    required this.line1,
    required this.line2,
    required this.postalCode,
    required this.city,
    required this.country,
  });
}

CreatePersonReqBody createPersonFromJson(String str) => CreatePersonReqBody.fromJson(json.decode(str));

String createPersonToJson(CreatePersonReqBody data) => json.encode(data.toJson());

class CreatePersonReqBody {
  String email;
  String lastName;
  String firstName;
  String mobileNumber;

  CreatePersonReqBody({
    required this.email,
    required this.lastName,
    required this.firstName,
    required this.mobileNumber,
  });

  factory CreatePersonReqBody.fromJson(Map<String, dynamic> json) => CreatePersonReqBody(
        email: json["email"],
        lastName: json["last_name"],
        firstName: json["first_name"],
        mobileNumber: json["mobile_number"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "last_name": lastName,
        "first_name": firstName,
        "mobile_number": mobileNumber,
      };
}

CreatePersonResponse createDeviceResponseFromJson(String str) => CreatePersonResponse.fromJson(json.decode(str));

String createDeviceResponseToJson(CreatePersonResponse data) => json.encode(data.toJson());

class CreatePersonResponse {
  String personId;

  CreatePersonResponse({
    required this.personId,
  });

  factory CreatePersonResponse.fromJson(Map<String, dynamic> json) => CreatePersonResponse(
        personId: json["person_id"],
      );

  Map<String, dynamic> toJson() => {
        "person_id": personId,
      };
}

CreateTaxIdentificationReqBody createTaxIdentificationReqBodyFromJson(String str) =>
    CreateTaxIdentificationReqBody.fromJson(json.decode(str));

String createTaxIdentificationReqBodyToJson(CreateTaxIdentificationReqBody data) => json.encode(data.toJson());

class CreateTaxIdentificationReqBody {
  String number;
  String country;
  bool primary;

  CreateTaxIdentificationReqBody({
    required this.number,
    required this.country,
    required this.primary,
  });

  factory CreateTaxIdentificationReqBody.fromJson(Map<String, dynamic> json) => CreateTaxIdentificationReqBody(
        number: json["number"],
        country: json["country"],
        primary: json["primary"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "country": country,
        "primary": primary,
      };
}

CreateTaxIdentificationResponse createTaxIdentificationResponseFromJson(String str) =>
    CreateTaxIdentificationResponse.fromJson(json.decode(str));

String createTaxIdentificationResponseToJson(CreateTaxIdentificationResponse data) => json.encode(data.toJson());

class CreateTaxIdentificationResponse {
  String id;
  String country;
  String number;
  dynamic reasonNoTin;
  dynamic reasonDescription;
  dynamic taxIdType;
  bool primary;
  dynamic validUntil;

  CreateTaxIdentificationResponse({
    required this.id,
    required this.country,
    required this.number,
    this.reasonNoTin,
    this.reasonDescription,
    this.taxIdType,
    required this.primary,
    this.validUntil,
  });

  factory CreateTaxIdentificationResponse.fromJson(Map<String, dynamic> json) => CreateTaxIdentificationResponse(
        id: json["id"],
        country: json["country"],
        number: json["number"],
        reasonNoTin: json["reason_no_tin"],
        reasonDescription: json["reason_description"],
        taxIdType: json["tax_id_type"],
        primary: json["primary"],
        validUntil: json["valid_until"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country": country,
        "number": number,
        "reason_no_tin": reasonNoTin,
        "reason_description": reasonDescription,
        "tax_id_type": taxIdType,
        "primary": primary,
        "valid_until": validUntil,
      };
}

CreateKycReqBody createKycReqBodyFromJson(String str) => CreateKycReqBody.fromJson(json.decode(str));

String createKycReqBodyToJson(CreateKycReqBody data) => json.encode(data.toJson());

class CreateKycReqBody {
  String method;
  String deviceData;

  CreateKycReqBody({
    required this.method,
    required this.deviceData,
  });

  factory CreateKycReqBody.fromJson(Map<String, dynamic> json) => CreateKycReqBody(
        method: json["method"],
        deviceData: json["device_data"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "device_data": deviceData,
      };
}

CreateKycResponse createKycResponseFromJson(String str) => CreateKycResponse.fromJson(json.decode(str));

String createKycResponseToJson(CreateKycResponse data) => json.encode(data.toJson());

class CreateKycResponse {
  String id;
  dynamic reference;
  dynamic url;
  String status;
  dynamic completedAt;
  String method;
  dynamic proofOfAddressType;
  dynamic proofOfAddressIssuedAt;
  dynamic language;
  dynamic iban;
  dynamic termsAndConditionsSignedAt;
  dynamic authorizationExpiresAt;
  dynamic confirmationExpiresAt;

  CreateKycResponse({
    required this.id,
    this.reference,
    this.url,
    required this.status,
    this.completedAt,
    required this.method,
    this.proofOfAddressType,
    this.proofOfAddressIssuedAt,
    this.language,
    this.iban,
    this.termsAndConditionsSignedAt,
    this.authorizationExpiresAt,
    this.confirmationExpiresAt,
  });

  factory CreateKycResponse.fromJson(Map<String, dynamic> json) => CreateKycResponse(
        id: json["id"],
        reference: json["reference"],
        url: json["url"],
        status: json["status"],
        completedAt: json["completed_at"],
        method: json["method"],
        proofOfAddressType: json["proof_of_address_type"],
        proofOfAddressIssuedAt: json["proof_of_address_issued_at"],
        language: json["language"],
        iban: json["iban"],
        termsAndConditionsSignedAt: json["terms_and_conditions_signed_at"],
        authorizationExpiresAt: json["authorization_expires_at"],
        confirmationExpiresAt: json["confirmation_expires_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "url": url,
        "status": status,
        "completed_at": completedAt,
        "method": method,
        "proof_of_address_type": proofOfAddressType,
        "proof_of_address_issued_at": proofOfAddressIssuedAt,
        "language": language,
        "iban": iban,
        "terms_and_conditions_signed_at": termsAndConditionsSignedAt,
        "authorization_expires_at": authorizationExpiresAt,
        "confirmation_expires_at": confirmationExpiresAt,
      };
}
