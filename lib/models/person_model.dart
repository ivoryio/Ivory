import 'dart:convert';

class Person {
  Person({
    this.id,
    this.salutation,
    this.title,
    this.firstName,
    this.lastName,
    this.address,
    this.contactAddress,
    this.email,
    this.mobileNumber,
    this.birthName,
    this.birthDate,
    this.birthCity,
    this.birthCountry,
    this.nationality,
    this.employmentStatus,
    this.jobTitle,
    this.taxInformation,
    this.fatcaRelevant,
    this.fatcaCrsConfirmedAt,
    this.businessPurpose,
    this.industry,
    this.industryKey,
    this.termsConditionsSignedAt,
    this.ownEconomicInterestSignedAt,
    this.flaggedByCompliance,
    this.expectedMonthlyRevenueCents,
    this.vatNumber,
    this.websiteSocialMedia,
    this.businessTradingName,
    this.naceCode,
    this.businessAddressLine1,
    this.businessAddressLine2,
    this.businessPostalCode,
    this.businessCity,
    this.businessCountry,
    this.screeningProgress,
    this.dataTermsSignedAt,
    this.amlFollowUpDate,
    this.amlConfirmedOn,
    this.annualIncomeRange,
    this.branch,
    this.workCountry,
    this.workProvince,
    this.selfDeclaredAsPep,
    this.internationalOperativityExpectation,
    this.riskClassificationStatus,
    this.customerVettingStatus,
    this.registrationNumber,
    this.legitimationValidUntil,
  });

  String? id;
  String? salutation;
  String? title;
  String? firstName;
  String? lastName;
  Address? address;
  Address? contactAddress;
  String? email;
  String? mobileNumber;
  String? birthName;
  DateTime? birthDate;
  String? birthCity;
  String? birthCountry;
  String? nationality;
  String? employmentStatus;
  String? jobTitle;
  TaxInformation? taxInformation;
  bool? fatcaRelevant;
  DateTime? fatcaCrsConfirmedAt;
  String? businessPurpose;
  String? industry;
  String? industryKey;
  DateTime? termsConditionsSignedAt;
  DateTime? ownEconomicInterestSignedAt;
  bool? flaggedByCompliance;
  int? expectedMonthlyRevenueCents;
  String? vatNumber;
  String? websiteSocialMedia;
  String? businessTradingName;
  String? naceCode;
  String? businessAddressLine1;
  String? businessAddressLine2;
  String? businessPostalCode;
  String? businessCity;
  String? businessCountry;
  String? screeningProgress;
  DateTime? dataTermsSignedAt;
  DateTime? amlFollowUpDate;
  DateTime? amlConfirmedOn;
  String? annualIncomeRange;
  String? branch;
  String? workCountry;
  String? workProvince;
  bool? selfDeclaredAsPep;
  List<String>? internationalOperativityExpectation;
  String? riskClassificationStatus;
  String? customerVettingStatus;
  String? registrationNumber;
  DateTime? legitimationValidUntil;

  factory Person.fromRawJson(String str) => Person.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"],
        salutation: json["salutation"],
        title: json["title"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        contactAddress: json["contact_address"] == null
            ? null
            : Address.fromJson(json["contact_address"]),
        email: json["email"],
        mobileNumber: json["mobile_number"],
        birthName: json["birth_name"],
        birthDate: json["birth_date"] == null
            ? null
            : DateTime.parse(json["birth_date"]),
        birthCity: json["birth_city"],
        birthCountry: json["birth_country"],
        nationality: json["nationality"],
        employmentStatus: json["employment_status"],
        jobTitle: json["job_title"],
        taxInformation: json["tax_information"] == null
            ? null
            : TaxInformation.fromJson(json["tax_information"]),
        fatcaRelevant: json["fatca_relevant"],
        fatcaCrsConfirmedAt: json["fatca_crs_confirmed_at"] == null
            ? null
            : DateTime.parse(json["fatca_crs_confirmed_at"]),
        businessPurpose: json["business_purpose"],
        industry: json["industry"],
        industryKey: json["industry_key"],
        termsConditionsSignedAt: json["terms_conditions_signed_at"] == null
            ? null
            : DateTime.parse(json["terms_conditions_signed_at"]),
        ownEconomicInterestSignedAt:
            json["own_economic_interest_signed_at"] == null
                ? null
                : DateTime.parse(json["own_economic_interest_signed_at"]),
        flaggedByCompliance: json["flagged_by_compliance"],
        expectedMonthlyRevenueCents: json["expected_monthly_revenue_cents"],
        vatNumber: json["vat_number"],
        websiteSocialMedia: json["website_social_media"],
        businessTradingName: json["business_trading_name"],
        naceCode: json["nace_code"],
        businessAddressLine1: json["business_address_line_1"],
        businessAddressLine2: json["business_address_line_2"],
        businessPostalCode: json["business_postal_code"],
        businessCity: json["business_city"],
        businessCountry: json["business_country"],
        screeningProgress: json["screening_progress"],
        dataTermsSignedAt: json["data_terms_signed_at"] == null
            ? null
            : DateTime.parse(json["data_terms_signed_at"]),
        amlFollowUpDate: json["aml_follow_up_date"] == null
            ? null
            : DateTime.parse(json["aml_follow_up_date"]),
        amlConfirmedOn: json["aml_confirmed_on"] == null
            ? null
            : DateTime.parse(json["aml_confirmed_on"]),
        annualIncomeRange: json["annual_income_range"],
        branch: json["branch"],
        workCountry: json["work_country"],
        workProvince: json["work_province"],
        selfDeclaredAsPep: json["self_declared_as_pep"],
        internationalOperativityExpectation:
            json["international_operativity_expectation"] == null
                ? []
                : List<String>.from(
                    json["international_operativity_expectation"]!
                        .map((x) => x)),
        riskClassificationStatus: json["risk_classification_status"],
        customerVettingStatus: json["customer_vetting_status"],
        registrationNumber: json["registration_number"],
        legitimationValidUntil: json["legitimation_valid_until"] == null
            ? null
            : DateTime.parse(json["legitimation_valid_until"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "salutation": salutation,
        "title": title,
        "first_name": firstName,
        "last_name": lastName,
        "address": address?.toJson(),
        "contact_address": contactAddress?.toJson(),
        "email": email,
        "mobile_number": mobileNumber,
        "birth_name": birthName,
        "birth_date":
            "${birthDate!.year.toString().padLeft(4, '0')}-${birthDate!.month.toString().padLeft(2, '0')}-${birthDate!.day.toString().padLeft(2, '0')}",
        "birth_city": birthCity,
        "birth_country": birthCountry,
        "nationality": nationality,
        "employment_status": employmentStatus,
        "job_title": jobTitle,
        "tax_information": taxInformation?.toJson(),
        "fatca_relevant": fatcaRelevant,
        "fatca_crs_confirmed_at": fatcaCrsConfirmedAt?.toIso8601String(),
        "business_purpose": businessPurpose,
        "industry": industry,
        "industry_key": industryKey,
        "terms_conditions_signed_at":
            termsConditionsSignedAt?.toIso8601String(),
        "own_economic_interest_signed_at":
            ownEconomicInterestSignedAt?.toIso8601String(),
        "flagged_by_compliance": flaggedByCompliance,
        "expected_monthly_revenue_cents": expectedMonthlyRevenueCents,
        "vat_number": vatNumber,
        "website_social_media": websiteSocialMedia,
        "business_trading_name": businessTradingName,
        "nace_code": naceCode,
        "business_address_line_1": businessAddressLine1,
        "business_address_line_2": businessAddressLine2,
        "business_postal_code": businessPostalCode,
        "business_city": businessCity,
        "business_country": businessCountry,
        "screening_progress": screeningProgress,
        "data_terms_signed_at": dataTermsSignedAt?.toIso8601String(),
        "aml_follow_up_date":
            "${amlFollowUpDate!.year.toString().padLeft(4, '0')}-${amlFollowUpDate!.month.toString().padLeft(2, '0')}-${amlFollowUpDate!.day.toString().padLeft(2, '0')}",
        "aml_confirmed_on":
            "${amlConfirmedOn!.year.toString().padLeft(4, '0')}-${amlConfirmedOn!.month.toString().padLeft(2, '0')}-${amlConfirmedOn!.day.toString().padLeft(2, '0')}",
        "annual_income_range": annualIncomeRange,
        "branch": branch,
        "work_country": workCountry,
        "work_province": workProvince,
        "self_declared_as_pep": selfDeclaredAsPep,
        "international_operativity_expectation":
            internationalOperativityExpectation == null
                ? []
                : List<dynamic>.from(
                    internationalOperativityExpectation!.map((x) => x)),
        "risk_classification_status": riskClassificationStatus,
        "customer_vetting_status": customerVettingStatus,
        "registration_number": registrationNumber,
        "legitimation_valid_until":
            "${legitimationValidUntil!.year.toString().padLeft(4, '0')}-${legitimationValidUntil!.month.toString().padLeft(2, '0')}-${legitimationValidUntil!.day.toString().padLeft(2, '0')}",
      };
}

class Address {
  Address({
    this.line1,
    this.line2,
    this.postalCode,
    this.city,
    this.country,
    this.state,
  });

  String? line1;
  String? line2;
  String? postalCode;
  String? city;
  String? country;
  String? state;

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json["line_1"],
        line2: json["line_2"],
        postalCode: json["postal_code"],
        city: json["city"],
        country: json["country"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "line_1": line1,
        "line_2": line2,
        "postal_code": postalCode,
        "city": city,
        "country": country,
        "state": state,
      };
}

class TaxInformation {
  TaxInformation({
    this.taxAssessment,
    this.maritalStatus,
  });

  String? taxAssessment;
  String? maritalStatus;

  factory TaxInformation.fromRawJson(String str) =>
      TaxInformation.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxInformation.fromJson(Map<String, dynamic> json) => TaxInformation(
        taxAssessment: json["tax_assessment"],
        maritalStatus: json["marital_status"],
      );

  Map<String, dynamic> toJson() => {
        "tax_assessment": taxAssessment,
        "marital_status": maritalStatus,
      };
}

CreatePersonReqBody createPersonFromJson(String str) =>
    CreatePersonReqBody.fromJson(json.decode(str));

String createPersonToJson(CreatePersonReqBody data) =>
    json.encode(data.toJson());

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

  factory CreatePersonReqBody.fromJson(Map<String, dynamic> json) =>
      CreatePersonReqBody(
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

CreatePersonResponse createDeviceResponseFromJson(String str) =>
    CreatePersonResponse.fromJson(json.decode(str));

String createDeviceResponseToJson(CreatePersonResponse data) =>
    json.encode(data.toJson());

class CreatePersonResponse {
  String personId;

  CreatePersonResponse({
    required this.personId,
  });

  factory CreatePersonResponse.fromJson(Map<String, dynamic> json) =>
      CreatePersonResponse(
        personId: json["person_id"],
      );

  Map<String, dynamic> toJson() => {
        "person_id": personId,
      };
}

CreateTaxIdentificationReqBody createTaxIdentificationReqBodyFromJson(
        String str) =>
    CreateTaxIdentificationReqBody.fromJson(json.decode(str));

String createTaxIdentificationReqBodyToJson(
        CreateTaxIdentificationReqBody data) =>
    json.encode(data.toJson());

class CreateTaxIdentificationReqBody {
  String number;
  String country;
  bool primary;

  CreateTaxIdentificationReqBody({
    required this.number,
    required this.country,
    required this.primary,
  });

  factory CreateTaxIdentificationReqBody.fromJson(Map<String, dynamic> json) =>
      CreateTaxIdentificationReqBody(
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

CreateTaxIdentificationResponse createTaxIdentificationResponseFromJson(
        String str) =>
    CreateTaxIdentificationResponse.fromJson(json.decode(str));

String createTaxIdentificationResponseToJson(
        CreateTaxIdentificationResponse data) =>
    json.encode(data.toJson());

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

  factory CreateTaxIdentificationResponse.fromJson(Map<String, dynamic> json) =>
      CreateTaxIdentificationResponse(
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

CreateKycReqBody createKycReqBodyFromJson(String str) =>
    CreateKycReqBody.fromJson(json.decode(str));

String createKycReqBodyToJson(CreateKycReqBody data) =>
    json.encode(data.toJson());

class CreateKycReqBody {
  String method;
  String deviceData;

  CreateKycReqBody({
    required this.method,
    required this.deviceData,
  });

  factory CreateKycReqBody.fromJson(Map<String, dynamic> json) =>
      CreateKycReqBody(
        method: json["method"],
        deviceData: json["device_data"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "device_data": deviceData,
      };
}

CreateKycResponse createKycResponseFromJson(String str) =>
    CreateKycResponse.fromJson(json.decode(str));

String createKycResponseToJson(CreateKycResponse data) =>
    json.encode(data.toJson());

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

  factory CreateKycResponse.fromJson(Map<String, dynamic> json) =>
      CreateKycResponse(
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
