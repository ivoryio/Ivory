import 'dart:convert';

class PersonAccount {
  PersonAccount({
    this.id,
    this.iban,
    this.bic,
    this.type,
    this.overdraft,
    this.balance,
    this.income,
    this.spending,
    this.availableBalance,
    this.lockingStatus,
    this.lockingReasons,
    this.accountLimit,
    this.personId,
    this.businessId,
    this.partnerId,
    this.openedAt,
    this.status,
    this.closedAt,
  });

  String? id;
  String? iban;
  String? bic;
  String? type;
  PersonAccountOverdraft? overdraft;
  PersonAccountCurrencyValue? balance;
  PersonAccountCurrencyValue? income;
  PersonAccountCurrencyValue? spending;
  PersonAccountCurrencyValue? availableBalance;
  String? lockingStatus;
  List<String>? lockingReasons;
  PersonAccountCurrencyValue? accountLimit;
  String? personId;
  String? businessId;
  String? partnerId;
  DateTime? openedAt;
  String? status;
  DateTime? closedAt;

  factory PersonAccount.fromRawJson(String str) =>
      PersonAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccount.fromJson(Map<String, dynamic> json) => PersonAccount(
        id: json["id"],
        iban: json["iban"],
        bic: json["bic"],
        type: json["type"],
        overdraft: json["overdraft"] == null
            ? null
            : PersonAccountOverdraft.fromJson(json["overdraft"]),
        balance: json["balance"] == null
            ? null
            : PersonAccountCurrencyValue.fromJson(json["balance"]),
        income: json["income"] == null
            ? null
            : PersonAccountCurrencyValue.fromJson(json["income"]),
        spending: json["spending"] == null
            ? null
            : PersonAccountCurrencyValue.fromJson(json["spending"]),
        availableBalance: json["available_balance"] == null
            ? null
            : PersonAccountCurrencyValue.fromJson(json["available_balance"]),
        lockingStatus: json["locking_status"],
        lockingReasons: json["locking_reasons"] == null
            ? []
            : List<String>.from(json["locking_reasons"]!.map((x) => x)),
        accountLimit: json["account_limit"] == null
            ? null
            : PersonAccountCurrencyValue.fromJson(json["account_limit"]),
        personId: json["person_id"],
        businessId: json["business_id"],
        partnerId: json["partner_id"],
        openedAt: json["opened_at"] == null
            ? null
            : DateTime.parse(json["opened_at"]),
        status: json["status"],
        closedAt: json["closed_at"] == null
            ? null
            : DateTime.parse(json["closed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "iban": iban,
        "bic": bic,
        "type": type,
        "overdraft": overdraft?.toJson(),
        "balance": balance?.toJson(),
        "income": income?.toJson(),
        "spending": spending?.toJson(),
        "available_balance": availableBalance?.toJson(),
        "locking_status": lockingStatus,
        "locking_reasons": lockingReasons == null
            ? []
            : List<dynamic>.from(lockingReasons!.map((x) => x)),
        "account_limit": accountLimit?.toJson(),
        "person_id": personId,
        "business_id": businessId,
        "partner_id": partnerId,
        "opened_at": openedAt?.toIso8601String(),
        "status": status,
        "closed_at": closedAt?.toIso8601String(),
      };
}

class PersonAccountCurrencyValue {
  PersonAccountCurrencyValue({
    this.unit,
    this.value,
    this.currency,
  });

  num? value;
  String? currency;
  String? unit;

  factory PersonAccountCurrencyValue.fromRawJson(String str) =>
      PersonAccountCurrencyValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccountCurrencyValue.fromJson(Map<String, dynamic> json) =>
      PersonAccountCurrencyValue(
        value: json["value"]?.toDouble(),
        currency: json["currency"],
        unit: json["unit"],
      );

  Map<String, dynamic> toJson() => {
        "unit": unit,
        "value": value,
        "currency": currency,
      };
}

class PersonAccountOverdraft {
  PersonAccountOverdraft({
    this.rate,
    this.limit,
  });

  double? rate;
  int? limit;

  factory PersonAccountOverdraft.fromRawJson(String str) =>
      PersonAccountOverdraft.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccountOverdraft.fromJson(Map<String, dynamic> json) =>
      PersonAccountOverdraft(
        rate: json["rate"]?.toDouble(),
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "limit": limit,
      };
}
