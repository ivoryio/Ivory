class PersonAccount {
  String? id;
  String? iban;
  String? bic;
  String? type;
  Balance? balance;
  Balance? availableBalance;
  String? lockingStatus;
  String? personId;

  PersonAccount(
      {this.id,
      this.iban,
      this.bic,
      this.type,
      this.balance,
      this.availableBalance,
      this.lockingStatus,
      this.personId});

  PersonAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iban = json['iban'];
    bic = json['bic'];
    type = json['type'];
    balance =
        json['balance'] != null ? Balance.fromJson(json['balance']) : null;
    availableBalance = json['available_balance'] != null
        ? Balance.fromJson(json['available_balance'])
        : null;
    lockingStatus = json['locking_status'];
    personId = json['person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['iban'] = iban;
    data['bic'] = bic;
    data['type'] = type;
    if (balance != null) {
      data['balance'] = balance!.toJson();
    }
    if (availableBalance != null) {
      data['available_balance'] = availableBalance!.toJson();
    }
    data['locking_status'] = lockingStatus;
    data['person_id'] = personId;
    return data;
  }
}

class Balance {
  int? value;

  Balance({this.value});

  Balance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}
