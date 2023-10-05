
class CreditCardApplication {
  String id;
  String externalCustomerId;
  String customerId;
  String accountId;
  String accountIban;
  String referenceAccountId;
  String status;
  String productType;
  DateTime billingStartDate;
  DateTime billingEndDate;
  ApprovedLimit? approvedLimit;
  ApprovedLimit? requestedLimit;
  ApprovedLimit? currentLimit;
  List<String>? declineReasons;
  RepaymentOptions? repaymentOptions;
  bool? statementWithDetails;
  bool? inDunning;
  DateTime? repaymentTypeSwitchAvailableDate;
  DateTime? createdAt;
  String? defaultInterestAccountId;
  String? interestStoringAccountId;
  DateTime? latestRepaymentTypeSwitchDate;
  DateTime? qesAt;

  CreditCardApplication({
    required this.id,
    required this.externalCustomerId,
    required this.customerId,
    required this.accountId,
    required this.accountIban,
    required this.referenceAccountId,
    required this.status,
    required this.productType,
    required this.billingStartDate,
    required this.billingEndDate,
    this.approvedLimit,
    this.requestedLimit,
    this.currentLimit,
    this.declineReasons,
    this.repaymentOptions,
    this.statementWithDetails,
    this.inDunning,
    this.repaymentTypeSwitchAvailableDate,
    this.createdAt,
    this.defaultInterestAccountId,
    this.interestStoringAccountId,
    this.latestRepaymentTypeSwitchDate,
    this.qesAt,
  });

  factory CreditCardApplication.fromJson(Map<String, dynamic> json) => CreditCardApplication(
        id: json["id"] ?? '',
        externalCustomerId: json["external_customer_id"] ?? '',
        customerId: json["customer_id"] ?? '',
        accountId: json["account_id"] ?? '',
        accountIban: json["account_iban"] ?? '',
        referenceAccountId: json["reference_account_id"] ?? '',
        status: json["status"] ?? '',
        productType: json["product_type"] ?? '',
        billingStartDate: DateTime.parse(json["billing_start_date"]),
        billingEndDate: DateTime.parse(json["billing_end_date"]),
        approvedLimit: json["approved_limit"] != null ? ApprovedLimit.fromJson(json["approved_limit"]) : null,
        requestedLimit: json["requested_limit"] != null ? ApprovedLimit.fromJson(json["requested_limit"]) : null,
        currentLimit: json["current_limit"] != null ? ApprovedLimit.fromJson(json["current_limit"]) : null,
        declineReasons: json["decline_reasons"] != null ? List<String>.from(json["decline_reasons"].map((x) => x)) : [],
        repaymentOptions:
            json["repayment_options"] != null ? RepaymentOptions.fromJson(json["repayment_options"]) : null,
        statementWithDetails: json["statement_with_details"] ?? false,
        inDunning: json["in_dunning"] ?? false,
        repaymentTypeSwitchAvailableDate: json["repayment_type_switch_available_date"] != null
            ? DateTime.parse(json["repayment_type_switch_available_date"])
            : null,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        defaultInterestAccountId: json["default_interest_account_id"] ?? '',
        interestStoringAccountId: json["interest_storing_account_id"] ?? '',
        latestRepaymentTypeSwitchDate: json["latest_repayment_type_switch_date"] != null
            ? DateTime.parse(json["latest_repayment_type_switch_date"])
            : null,
        qesAt: json["qes_at"] != null ? DateTime.parse(json["qes_at"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "external_customer_id": externalCustomerId,
        "customer_id": customerId,
        "account_id": accountId,
        "account_iban": accountIban,
        "reference_account_id": referenceAccountId,
        "status": status,
        "product_type": productType,
        "billing_start_date":
            "${billingStartDate.year.toString().padLeft(4, '0')}-${billingStartDate.month.toString().padLeft(2, '0')}-${billingStartDate.day.toString().padLeft(2, '0')}",
        "billing_end_date":
            "${billingEndDate.year.toString().padLeft(4, '0')}-${billingEndDate.month.toString().padLeft(2, '0')}-${billingEndDate.day.toString().padLeft(2, '0')}",
        "approved_limit": approvedLimit?.toJson(),
        "requested_limit": requestedLimit?.toJson(),
        "current_limit": currentLimit?.toJson(),
        "decline_reasons": declineReasons,
        "repayment_options": repaymentOptions?.toJson(),
        "statement_with_details": statementWithDetails ?? false,
        "in_dunning": inDunning ?? false,
        "repayment_type_switch_available_date":
            "${repaymentTypeSwitchAvailableDate?.year.toString().padLeft(4, '0')}-${repaymentTypeSwitchAvailableDate?.month.toString().padLeft(2, '0')}-${repaymentTypeSwitchAvailableDate?.day.toString().padLeft(2, '0')}",
        "created_at":
            "${createdAt?.year.toString().padLeft(4, '0')}-${createdAt?.month.toString().padLeft(2, '0')}-${createdAt?.day.toString().padLeft(2, '0')}",
        "default_interest_account_id": defaultInterestAccountId,
        "interest_storing_account_id": interestStoringAccountId,
        "latest_repayment_type_switch_date":
            "${latestRepaymentTypeSwitchDate?.year.toString().padLeft(4, '0')}-${latestRepaymentTypeSwitchDate?.month.toString().padLeft(2, '0')}-${latestRepaymentTypeSwitchDate?.day.toString().padLeft(2, '0')}",
        "qes_at":
            "${qesAt?.year.toString().padLeft(4, '0')}-${qesAt?.month.toString().padLeft(2, '0')}-${qesAt?.day.toString().padLeft(2, '0')}",
      };
}

class ApprovedLimit {
  int value;
  Unit unit;
  Currency currency;

  ApprovedLimit({
    required this.value,
    required this.unit,
    required this.currency,
  });

  factory ApprovedLimit.fromJson(Map<String, dynamic> json) => ApprovedLimit(
        value: json["value"] ?? 0,
        unit: unitValues.map[json["unit"]] ?? Unit.CENTS,
        currency: currencyValues.map[json["currency"]] ?? Currency.EUR,
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unitValues.reverse[unit] ?? 'cents',
        "currency": currencyValues.reverse[currency] ?? 'EUR',
      };
}

enum Currency { EUR }

final currencyValues = EnumValues({"EUR": Currency.EUR});

enum Unit { CENTS }

final unitValues = EnumValues({"cents": Unit.CENTS});

class RepaymentOptions {
  String upcomingType;
  ApprovedLimit minimumAmount;
  int minimumPercentage;
  String currentType;
  String upcomingBillingCycle;
  String currentBillingCycle;
  int gracePeriodInDays;
  ApprovedLimit minimumAmountLowerThreshold;
  ApprovedLimit minimumAmountUpperThreshold;
  int minimumPercentageLowerThreshold;
  int minimumPercentageUpperThreshold;

  RepaymentOptions({
    required this.upcomingType,
    required this.minimumAmount,
    required this.minimumPercentage,
    required this.currentType,
    required this.upcomingBillingCycle,
    required this.currentBillingCycle,
    required this.gracePeriodInDays,
    required this.minimumAmountLowerThreshold,
    required this.minimumAmountUpperThreshold,
    required this.minimumPercentageLowerThreshold,
    required this.minimumPercentageUpperThreshold,
  });

  factory RepaymentOptions.fromJson(Map<String, dynamic> json) => RepaymentOptions(
        upcomingType: json["upcoming_type"] ?? '',
        minimumAmount: ApprovedLimit.fromJson(json["minimum_amount"]),
        minimumPercentage: json["minimum_percentage"] ?? 0,
        currentType: json["current_type"] ?? '',
        upcomingBillingCycle: json["upcoming_billing_cycle"] ?? '',
        currentBillingCycle: json["current_billing_cycle"] ?? '',
        gracePeriodInDays: json["grace_period_in_days"] ?? 0,
        minimumAmountLowerThreshold: ApprovedLimit.fromJson(json["minimum_amount_lower_threshold"]),
        minimumAmountUpperThreshold: ApprovedLimit.fromJson(json["minimum_amount_upper_threshold"]),
        minimumPercentageLowerThreshold: json["minimum_percentage_lower_threshold"] ?? 0,
        minimumPercentageUpperThreshold: json["minimum_percentage_upper_threshold"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "upcoming_type": upcomingType,
        "minimum_amount": minimumAmount.toJson(),
        "minimum_percentage": minimumPercentage,
        "current_type": currentType,
        "upcoming_billing_cycle": upcomingBillingCycle,
        "current_billing_cycle": currentBillingCycle,
        "grace_period_in_days": gracePeriodInDays,
        "minimum_amount_lower_threshold": minimumAmountLowerThreshold.toJson(),
        "minimum_amount_upper_threshold": minimumAmountUpperThreshold.toJson(),
        "minimum_percentage_lower_threshold": minimumPercentageLowerThreshold,
        "minimum_percentage_upper_threshold": minimumPercentageUpperThreshold,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
