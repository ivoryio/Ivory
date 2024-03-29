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
      'kty': kty ?? _defaultJWKkty,
      'alg': alg ?? _defaultJWKalg,
      'use': use ?? _defaultJWKuse,
      'kid': kid ?? "",
      'n': n,
      'e': e,
    };

    final sortedMap = Map.fromEntries(jwkMap.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
    final compactString = sortedMap.entries.map((entry) => "${entry.key}:${entry.value}").join(";");

    return compactString;
  }
}

String _defaultJWKalg = "RS256";
String _defaultJWKuse = "enc";
String _defaultJWKkty = "RSA";
