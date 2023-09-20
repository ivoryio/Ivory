import 'dart:convert';

class Jwk {
  String n;
  String e;
  String? kty;
  String? alg;
  String? use;
  String? kid;

  Jwk({
    required this.n,
    required this.e,
    this.kty,
    this.alg,
    this.use,
    this.kid,
  });

  factory Jwk.fromJson(Map<String, dynamic> json) => Jwk(
        n: json['n'],
        e: json['e'],
        kty: json['kty'],
        alg: json['alg'],
        use: json['use'],
        kid: json['kid'],
      );

  Map<String, dynamic> toJson() => {
        "n": n,
        "e": e,
        "kty": kty ?? _defaultJWKkty,
        "alg": alg ?? _defaultJWKalg,
        "use": use ?? _defaultJWKuse,
        "kid": kid ?? "",
      };

  String toAlphabeticJson() {
    Map<String, dynamic> jwkMap = {
      'kty': kty,
      'alg': alg,
      'use': use,
      'kid': kid,
      'n': n,
      'e': e,
    };

    var sortedMap = Map.fromEntries(jwkMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));

    var jsonString = jsonEncode(sortedMap);

    // Remove whitespace characters from the JSON string
    var compactJsonString = jsonString.replaceAll(RegExp(r'\s+'), '');

    return compactJsonString;
  }
}

String _defaultJWKalg = "RS256";
String _defaultJWKuse = "enc";
String _defaultJWKkty = "RSA";
