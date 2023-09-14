import 'package:jose/jose.dart';

class CryptoEncrypt {
  static Future<String> encryptAndCreateJWEforChangePin({
    required Map<String, dynamic> jwkJson,
    required String payloadToEncrypt,
  }) async {
    final builder = JsonWebEncryptionBuilder();
    builder.stringContent = payloadToEncrypt;
    builder.setProtectedHeader('createdAt', DateTime.now().toIso8601String());

    final jwk = JsonWebKey.rsa(
      modulus: jwkJson['n'],
      exponent: jwkJson['e'],
      keyId: jwkJson['kid'],
      algorithm: jwkJson['alg'],
    );

    builder.addRecipient(
      jwk,
      algorithm: 'RSA-OAEP-256',
    );
    builder.encryptionAlgorithm = 'A256CBC-HS512';

    final jwe = builder.build();
    return jwe.toCompactSerialization();
  }
}
