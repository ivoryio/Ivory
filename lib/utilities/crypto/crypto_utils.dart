import 'dart:convert';

import 'package:pointycastle/pointycastle.dart';
import 'package:solarisdemo/models/crypto/jwk.dart';

class CryptoUtils {
  static Jwk convertRSAPublicKeyToJWK({
    required RSAPublicKey rsaPublicKey,
  }) {
    return Jwk(
      e: _base64UrlEncodeBigInt(rsaPublicKey.exponent!),
      n: _base64UrlEncodeBigInt(rsaPublicKey.modulus!),
    );
  }

  static String _base64UrlEncodeBigInt(BigInt number) {
    List<int> byteArray = bigIntToBytes(number);
    return base64UrlEncode(byteArray);
  }

  static List<int> bigIntToBytes(BigInt number) {
    var size = (number.bitLength + 7) >> 3;
    var result = List<int>.filled(size, 0);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & (BigInt.from(0xff))).toInt();
      number = number >> 8;
    }
    return result;
  }
}
