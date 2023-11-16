import 'dart:convert';

class AccountData {
  String ownerName;
  String iban;

  AccountData({
    required this.ownerName,
    required this.iban,
  });

  factory AccountData.fromRawJson(String str) => AccountData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccountData.fromJson(Map<String, dynamic> json) => AccountData(
        ownerName: (json['name'] as String).toLowerCase().contains("solaris") ? "Reference account" : json['name'],
        iban: json['iban'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': ownerName,
        'iban': iban,
      };

  factory AccountData.empty() => AccountData(
        ownerName: '',
        iban: '',
      );
}
