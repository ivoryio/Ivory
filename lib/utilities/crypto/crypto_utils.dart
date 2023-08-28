import 'dart:convert';

import 'package:pointycastle/pointycastle.dart';
import 'package:solarisdemo/models/bank_card.dart';

class CryptoUtils {
  Jwk convertRSAPublicKeyToJWK({
    required RSAPublicKey rsaPublicKey,
  }) {
    return Jwk(
      e: _base64UrlEncodeBigInt(rsaPublicKey.exponent!),
      n: _base64UrlEncodeBigInt(rsaPublicKey.modulus!),
    );
  }

  String _base64UrlEncodeBigInt(BigInt number) {
    List<int> byteArray = bigIntToBytes(number);
    return base64UrlEncode(byteArray);
  }

  List<int> bigIntToBytes(BigInt number) {
    var size = (number.bitLength + 7) >> 3;
    var result = List<int>.filled(size, 0);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & (BigInt.from(0xff))).toInt();
      number = number >> 8;
    }
    return result;
  }
}