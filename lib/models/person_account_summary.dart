import 'dart:convert';

import 'package:solarisdemo/utilities/constants.dart';

class PersonAccountSummary {
  PersonAccountSummary({
    this.id,
    this.income,
    this.spending,
    this.iban,
    this.bic,
    this.balance,
    this.availableBalance,
    this.creditLimit,
    this.outstandingAmount,
  });

  String? id;
  double? income;
  double? spending;
  String? iban;
  String? bic;
  Balance? balance;
  Balance? availableBalance;
  double? creditLimit;
  double? outstandingAmount;

  factory PersonAccountSummary.fromRawJson(String str) => PersonAccountSummary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccountSummary.fromJson(Map<String, dynamic> json) => PersonAccountSummary(
        id: json["id"] ?? emptyStringValue,
        income: json["income"]?.toDouble() ?? zeroValue,
        spending: json["spending"]?.toDouble() ?? zeroValue,
        iban: json["iban"] ?? emptyStringValue,
        bic: json["bic"] ?? emptyStringValue,
        balance: json["balance"] == null ? null : Balance.fromJson(json["balance"]),
        availableBalance: json["availableBalance"] == null ? null : Balance.fromJson(json["availableBalance"]),
        creditLimit: json["credit_limit"]?.toDouble() ?? zeroValue,
        outstandingAmount: json["outstanding_amount"]?.toDouble() ?? zeroValue,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "income": income,
        "spending": spending,
        "iban": iban,
        "bic": bic,
        "balance": balance?.toJson(),
        "available_balance": availableBalance?.toJson(),
        "credit_limit": creditLimit,
        "outstanding_amount": outstandingAmount,
      };
}

class Balance {
  Balance({
    this.currency,
    this.value,
    this.unit,
  });

  String? currency;
  String? unit;
  num? value;

  factory Balance.fromRawJson(String str) => Balance.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        currency: json["currency"] ?? defaultCurrency,
        value: json["value"]?.toDouble() ?? zeroValue,
        unit: json["unit"] ?? zeroValue,
      );

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "value": value,
        "unit": unit,
      };
}
