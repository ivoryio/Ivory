import 'dart:convert';

class AmountValue {
  final num value;
  final String currency;
  final String unit;

  AmountValue({
    required this.value,
    required this.unit,
    required this.currency,
  });

  factory AmountValue.fromRawJson(String str) => AmountValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AmountValue.fromJson(Map<String, dynamic> json) => AmountValue(
        value: json["value"]?.toDouble() ?? 0,
        unit: json["unit"] ?? "cents",
        currency: json["currency"] ?? "EUR",
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "unit": unit,
        "currency": currency,
      };

  factory AmountValue.empty() => AmountValue(
        value: 0,
        unit: 'cents',
        currency: 'EUR',
      );
}
