import 'dart:convert';

class Person {
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
  String? birthDate;
  String? birthCity;
  String? birthCountry;
  String? nationality;
  String? employmentStatus;
  String? jobTitle;
  TaxInformation? taxInformation;
  bool? fatcaRelevant;
  String? fatcaCrsConfirmedAt;
  String? businessPurpose;
  String? industry;
  String? industryKey;
  String? termsConditionsSignedAt;
  String? ownEconomicInterestSignedAt;
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
  String? dataTermsSignedAt;
  String? amlFollowUpDate;
  String? amlConfirmedOn;
  String? annualIncomeRange;
  String? branch;
  String? workCountry;
  String? workProvince;
  bool? selfDeclaredAsPep;
  List<String>? internationalOperativityExpectation;
  String? riskClassificationStatus;
  String? customerVettingStatus;
  String? registrationNumber;
  String? legitimationValidUntil;

  Person(
      {this.id,
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
      this.legitimationValidUntil});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salutation = json['salutation'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
    contactAddress = json['contact_address'] != null
        ? Address.fromJson(json['contact_address'])
        : null;
    email = json['email'];
    mobileNumber = json['mobile_number'];
    birthName = json['birth_name'];
    birthDate = json['birth_date'];
    birthCity = json['birth_city'];
    birthCountry = json['birth_country'];
    nationality = json['nationality'];
    employmentStatus = json['employment_status'];
    jobTitle = json['job_title'];
    taxInformation = json['tax_information'] != null
        ? TaxInformation.fromJson(json['tax_information'])
        : null;
    fatcaRelevant = json['fatca_relevant'];
    fatcaCrsConfirmedAt = json['fatca_crs_confirmed_at'];
    businessPurpose = json['business_purpose'];
    industry = json['industry'];
    industryKey = json['industry_key'];
    termsConditionsSignedAt = json['terms_conditions_signed_at'];
    ownEconomicInterestSignedAt = json['own_economic_interest_signed_at'];
    flaggedByCompliance = json['flagged_by_compliance'];
    expectedMonthlyRevenueCents = json['expected_monthly_revenue_cents'];
    vatNumber = json['vat_number'];
    websiteSocialMedia = json['website_social_media'];
    businessTradingName = json['business_trading_name'];
    naceCode = json['nace_code'];
    businessAddressLine1 = json['business_address_line_1'];
    businessAddressLine2 = json['business_address_line_2'];
    businessPostalCode = json['business_postal_code'];
    businessCity = json['business_city'];
    businessCountry = json['business_country'];
    screeningProgress = json['screening_progress'];
    dataTermsSignedAt = json['data_terms_signed_at'];
    amlFollowUpDate = json['aml_follow_up_date'];
    amlConfirmedOn = json['aml_confirmed_on'];
    annualIncomeRange = json['annual_income_range'];
    branch = json['branch'];
    workCountry = json['work_country'];
    workProvince = json['work_province'];
    selfDeclaredAsPep = json['self_declared_as_pep'];
    // check how to solve this
    internationalOperativityExpectation =
        (jsonDecode(json['international_operativity_expectation'])
                as List<dynamic>)
            .cast<String>();

    riskClassificationStatus = json['risk_classification_status'];
    customerVettingStatus = json['customer_vetting_status'];
    registrationNumber = json['registration_number'];
    legitimationValidUntil = json['legitimation_valid_until'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salutation'] = salutation;
    data['title'] = title;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (contactAddress != null) {
      data['contact_address'] = contactAddress!.toJson();
    }
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['birth_name'] = birthName;
    data['birth_date'] = birthDate;
    data['birth_city'] = birthCity;
    data['birth_country'] = birthCountry;
    data['nationality'] = nationality;
    data['employment_status'] = employmentStatus;
    data['job_title'] = jobTitle;
    if (taxInformation != null) {
      data['tax_information'] = taxInformation!.toJson();
    }
    data['fatca_relevant'] = fatcaRelevant;
    data['fatca_crs_confirmed_at'] = fatcaCrsConfirmedAt;
    data['business_purpose'] = businessPurpose;
    data['industry'] = industry;
    data['industry_key'] = industryKey;
    data['terms_conditions_signed_at'] = termsConditionsSignedAt;
    data['own_economic_interest_signed_at'] = ownEconomicInterestSignedAt;
    data['flagged_by_compliance'] = flaggedByCompliance;
    data['expected_monthly_revenue_cents'] = expectedMonthlyRevenueCents;
    data['vat_number'] = vatNumber;
    data['website_social_media'] = websiteSocialMedia;
    data['business_trading_name'] = businessTradingName;
    data['nace_code'] = naceCode;
    data['business_address_line_1'] = businessAddressLine1;
    data['business_address_line_2'] = businessAddressLine2;
    data['business_postal_code'] = businessPostalCode;
    data['business_city'] = businessCity;
    data['business_country'] = businessCountry;
    data['screening_progress'] = screeningProgress;
    data['data_terms_signed_at'] = dataTermsSignedAt;
    data['aml_follow_up_date'] = amlFollowUpDate;
    data['aml_confirmed_on'] = amlConfirmedOn;
    data['annual_income_range'] = annualIncomeRange;
    data['branch'] = branch;
    data['work_country'] = workCountry;
    data['work_province'] = workProvince;
    data['self_declared_as_pep'] = selfDeclaredAsPep;
    data['international_operativity_expectation'] =
        internationalOperativityExpectation;
    data['risk_classification_status'] = riskClassificationStatus;
    data['customer_vetting_status'] = customerVettingStatus;
    data['registration_number'] = registrationNumber;
    data['legitimation_valid_until'] = legitimationValidUntil;
    return data;
  }
}

class Address {
  String? line1;
  String? line2;
  String? postalCode;
  String? city;
  String? country;
  String? state;

  Address(
      {this.line1,
      this.line2,
      this.postalCode,
      this.city,
      this.country,
      this.state});

  Address.fromJson(Map<String, dynamic> json) {
    line1 = json['line_1'];
    line2 = json['line_2'];
    postalCode = json['postal_code'];
    city = json['city'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line_1'] = line1;
    data['line_2'] = line2;
    data['postal_code'] = postalCode;
    data['city'] = city;
    data['country'] = country;
    data['state'] = state;
    return data;
  }
}

class TaxInformation {
  String? taxAssessment;
  String? maritalStatus;

  TaxInformation({this.taxAssessment, this.maritalStatus});

  TaxInformation.fromJson(Map<String, dynamic> json) {
    taxAssessment = json['tax_assessment'];
    maritalStatus = json['marital_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tax_assessment'] = taxAssessment;
    data['marital_status'] = maritalStatus;
    return data;
  }
}
