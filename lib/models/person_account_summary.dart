import 'dart:convert';

class PersonAccountSummary {
  PersonAccountSummary({
    this.id,
    this.account,
    this.income,
    this.spending,
  });

  dynamic id;
  Account? account;
  double? income;
  double? spending;

  factory PersonAccountSummary.fromRawJson(String str) =>
      PersonAccountSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccountSummary.fromJson(Map<String, dynamic> json) =>
      PersonAccountSummary(
        id: json["id"],
        account:
            json["account"] == null ? null : Account.fromJson(json["account"]),
        income: json["income"]?.toDouble(),
        spending: json["spending"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account": account?.toJson(),
        "income": income,
        "spending": spending,
      };
}

class Account {
  Account({
    this.id,
    this.iban,
    this.bic,
    this.type,
    this.balance,
    this.availableBalance,
    this.lockingStatus,
    this.personId,
  });

  String? id;
  String? iban;
  String? bic;
  String? type;
  Balance? balance;
  Balance? availableBalance;
  String? lockingStatus;
  String? personId;

  factory Account.fromRawJson(String str) => Account.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json["id"],
        iban: json["iban"],
        bic: json["bic"],
        type: json["type"],
        balance:
            json["balance"] == null ? null : Balance.fromJson(json["balance"]),
        availableBalance: json["available_balance"] == null
            ? null
            : Balance.fromJson(json["available_balance"]),
        lockingStatus: json["locking_status"],
        personId: json["person_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "iban": iban,
        "bic": bic,
        "type": type,
        "balance": balance?.toJson(),
        "available_balance": availableBalance?.toJson(),
        "locking_status": lockingStatus,
        "person_id": personId,
      };
}

class Balance {
  Balance({
    this.value,
  });

  num? value;

  factory Balance.fromRawJson(String str) => Balance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
      };
}
