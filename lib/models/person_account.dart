import 'dart:convert';

import 'amount_value.dart';

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
  AmountValue? balance;
  AmountValue? income;
  AmountValue? spending;
  AmountValue? availableBalance;
  String? lockingStatus;
  List<String>? lockingReasons;
  AmountValue? accountLimit;
  String? personId;
  String? businessId;
  String? partnerId;
  DateTime? openedAt;
  String? status;
  DateTime? closedAt;

  factory PersonAccount.fromRawJson(String str) => PersonAccount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccount.fromJson(Map<String, dynamic> json) => PersonAccount(
        id: json["id"],
        iban: json["iban"],
        bic: json["bic"],
        type: json["type"],
        overdraft: json["overdraft"] == null ? null : PersonAccountOverdraft.fromJson(json["overdraft"]),
        balance: json["balance"] == null ? null : AmountValue.fromJson(json["balance"]),
        income: json["income"] == null ? null : AmountValue.fromJson(json["income"]),
        spending: json["spending"] == null ? null : AmountValue.fromJson(json["spending"]),
        availableBalance: json["available_balance"] == null ? null : AmountValue.fromJson(json["available_balance"]),
        lockingStatus: json["locking_status"],
        lockingReasons:
            json["locking_reasons"] == null ? [] : List<String>.from(json["locking_reasons"]!.map((x) => x)),
        accountLimit: json["account_limit"] == null ? null : AmountValue.fromJson(json["account_limit"]),
        personId: json["person_id"],
        businessId: json["business_id"],
        partnerId: json["partner_id"],
        openedAt: json["opened_at"] == null ? null : DateTime.parse(json["opened_at"]),
        status: json["status"],
        closedAt: json["closed_at"] == null ? null : DateTime.parse(json["closed_at"]),
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
        "locking_reasons": lockingReasons == null ? [] : List<dynamic>.from(lockingReasons!.map((x) => x)),
        "account_limit": accountLimit?.toJson(),
        "person_id": personId,
        "business_id": businessId,
        "partner_id": partnerId,
        "opened_at": openedAt?.toIso8601String(),
        "status": status,
        "closed_at": closedAt?.toIso8601String(),
      };
}

class PersonAccountOverdraft {
  PersonAccountOverdraft({
    this.rate,
    this.limit,
  });

  double? rate;
  int? limit;

  factory PersonAccountOverdraft.fromRawJson(String str) => PersonAccountOverdraft.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonAccountOverdraft.fromJson(Map<String, dynamic> json) => PersonAccountOverdraft(
        rate: json["rate"]?.toDouble(),
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "rate": rate,
        "limit": limit,
      };
}

CreateAccountResponse createAccountResponseFromJson(String str) => CreateAccountResponse.fromJson(json.decode(str));

String createAccountResponseToJson(CreateAccountResponse data) => json.encode(data.toJson());

class CreateAccountResponse {
  String personId;
  String accountId;

  CreateAccountResponse({
    required this.personId,
    required this.accountId,
  });

  factory CreateAccountResponse.fromJson(Map<String, dynamic> json) => CreateAccountResponse(
        personId: json["person_id"],
        accountId: json["account_id"],
      );

  Map<String, dynamic> toJson() => {
        "person_id": personId,
        "account_id": accountId,
      };
}
