import 'dart:convert';

class Jwe {
  String alg;
  String enc;

  Jwe({
    required this.alg,
    required this.enc,
  });

  factory Jwe.fromJson(Map<String, dynamic> json) {
    return Jwe(
      alg: json['alg'],
      enc: json['enc'],
    );
  }

  factory Jwe.defaultValues() {
    return Jwe(
      alg: _defaultJWEalg,
      enc: _defaultJWEenc,
    );
  }

  Map<String, dynamic> toJson() => {
        "alg": alg,
        "enc": enc,
      };
}


// You can define your default values here
String _defaultJWEalg = "RSA1_5";
String _defaultJWEenc = "A256GCM";
