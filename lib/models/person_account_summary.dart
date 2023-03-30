class PersonAccountSummary {
  PersonAccountSummary({
    required this.id,
    required this.email,
    required this.lastName,
    required this.salutation,
    required this.firstName,
    required this.birthDate,
    required this.birthCity,
    required this.nationality,
    required this.birthCountry,
    required this.mobileNumber,
    required this.employmentStatus,
    required this.account,
    required this.address,
    required this.income,
    required this.spending,
  });
  late final String id;
  late final String email;
  late final String lastName;
  late final String salutation;
  late final String firstName;
  late final String birthDate;
  late final String birthCity;
  late final String nationality;
  late final String birthCountry;
  late final String mobileNumber;
  late final String employmentStatus;
  late final Account account;
  late final Address address;
  late final num income;
  late final num spending;

  PersonAccountSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    lastName = json['last_name'];
    salutation = json['salutation'];
    firstName = json['first_name'];
    birthDate = json['birth_date'];
    birthCity = json['birth_city'];
    nationality = json['nationality'];
    birthCountry = json['birth_country'];
    mobileNumber = json['mobile_number'];
    employmentStatus = json['employment_status'];
    account = Account.fromJson(json['account']);
    address = Address.fromJson(json['address']);
    income = json['income'];
    spending = json['spending'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['last_name'] = lastName;
    data['salutation'] = salutation;
    data['first_name'] = firstName;
    data['birth_date'] = birthDate;
    data['birth_city'] = birthCity;
    data['nationality'] = nationality;
    data['birth_country'] = birthCountry;
    data['mobile_number'] = mobileNumber;
    data['employment_status'] = employmentStatus;
    data['account'] = account.toJson();
    data['address'] = address.toJson();
    data['income'] = income;
    data['spending'] = spending;
    return data;
  }
}

class Account {
  Account({
    required this.id,
    required this.iban,
    required this.bic,
    required this.type,
    required this.personId,
    required this.balance,
    required this.senderName,
    required this.lockingStatus,
    required this.availableBalance,
    required this.seizureProtection,
    required this.reservations,
    required this.fraudReservations,
    required this.pendingReservation,
  });
  late final String id;
  late final String iban;
  late final String bic;
  late final String type;
  late final String personId;
  late final Balance balance;
  late final String senderName;
  late final String lockingStatus;
  late final AvailableBalance availableBalance;
  late final String seizureProtection;
  late final List<dynamic> reservations;
  late final List<dynamic> fraudReservations;
  late final PendingReservation pendingReservation;

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iban = json['iban'];
    bic = json['bic'];
    type = json['type'];
    personId = json['person_id'];
    balance = Balance.fromJson(json['balance']);
    senderName = json['sender_name'];
    lockingStatus = json['locking_status'];
    availableBalance = AvailableBalance.fromJson(json['available_balance']);
    if (json['seizure_protection'] != null) {
      seizureProtection = json['seizure_protection'];
    }

    reservations = List.castFrom<dynamic, dynamic>(json['reservations']);
    fraudReservations =
        List.castFrom<dynamic, dynamic>(json['fraudReservations']);
    pendingReservation =
        PendingReservation.fromJson(json['pendingReservation']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['iban'] = iban;
    data['bic'] = bic;
    data['type'] = type;
    data['person_id'] = personId;
    data['balance'] = balance.toJson();
    data['sender_name'] = senderName;
    data['locking_status'] = lockingStatus;
    data['available_balance'] = availableBalance.toJson();
    data['seizure_protection'] = seizureProtection;
    data['reservations'] = reservations;
    data['fraudReservations'] = fraudReservations;
    data['pendingReservation'] = pendingReservation.toJson();
    return data;
  }
}

class Balance {
  Balance({
    required this.value,
  });
  late final num value;

  Balance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}

class AvailableBalance {
  AvailableBalance({
    required this.value,
  });
  late final num value;

  AvailableBalance.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}

class PendingReservation {
  PendingReservation();

  PendingReservation.fromJson(Map json);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    return data;
  }
}

class Address {
  Address({
    required this.line_1,
    required this.postalCode,
    required this.city,
    required this.country,
  });
  late final String line_1;
  late final String postalCode;
  late final String city;
  late final String country;

  Address.fromJson(Map<String, dynamic> json) {
    line_1 = json['line_1'];
    postalCode = json['postal_code'];
    city = json['city'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['line_1'] = line_1;
    data['postal_code'] = postalCode;
    data['city'] = city;
    data['country'] = country;
    return data;
  }
}
