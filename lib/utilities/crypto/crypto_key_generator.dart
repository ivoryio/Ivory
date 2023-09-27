import 'dart:math';
import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart';

class CryptoKeyGenerator {
  static CryptoKeyPair generateECKeyPair() {
    var keyPair = _createECKeyGenerator().generateKeyPair();
    var publicKeyUncompressedForm = _toUncompressedForm(keyPair.publicKey as ECPublicKey);

    var stop = false;
    var i = 0;
    while (i < 10 && stop != true) {
      if (publicKeyUncompressedForm.length % 2 != 0) {
        keyPair = _createECKeyGenerator().generateKeyPair();
        publicKeyUncompressedForm = _toUncompressedForm(keyPair.publicKey as ECPublicKey);
        i++;
      } else {
        stop = true;
      }
    }
    print('publicUncompressedForm: $publicKeyUncompressedForm');
    print('privateKey: ${_toHex(keyPair.privateKey as ECPrivateKey)}');

    return CryptoKeyPair(
      publicKey: publicKeyUncompressedForm,
      privateKey: _toHex(keyPair.privateKey as ECPrivateKey),
    );
  }

  static RSAKeyPair generateRSAKeyPair() {
    final keyPair = _createRSAKeyGenerator().generateKeyPair();
    final publicKey = keyPair.publicKey as RSAPublicKey;
    final privateKey = keyPair.privateKey as RSAPrivateKey;
    return RSAKeyPair(
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }

  static ECKeyGenerator _createECKeyGenerator() {
    final keyGen = ECKeyGenerator();

    keyGen.init(ParametersWithRandom(ECKeyGeneratorParameters(ECCurve_prime256v1()), _secureRandom()));
    // keyGen.init(ParametersWithRandom(ECKeyGeneratorParameters(ECCurve_secp256r1()), _secureRandom()));
    return keyGen;
  }

  static RSAKeyGenerator _createRSAKeyGenerator() {
    final keyGen = RSAKeyGenerator();

    keyGen.init(ParametersWithRandom(RSAKeyGeneratorParameters(BigInt.parse('65537'), 2048, 64), _secureRandom()));
    return keyGen;
  }

  static String _toUncompressedForm(ECPublicKey public) {
    final point = public.Q!;
    final x = point.x!.toBigInteger();
    final xHex = x!.toRadixString(16);
    final y = point.y!.toBigInteger();
    final yHex = y!.toRadixString(16);
    final encodedPublicKey = "04$xHex$yHex";
    return encodedPublicKey;
  }

  static String _toHex(ECPrivateKey private) => private.d!.toRadixString(16);

  static SecureRandom _secureRandom() {
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }

    return FortunaRandom()..seed(KeyParameter(Uint8List.fromList(seeds)));
  }
}

class CryptoKeyPair {
  final String publicKey;
  final String privateKey;

  CryptoKeyPair({
    required this.publicKey,
    required this.privateKey,
  });
}

class RSAKeyPair {
  final RSAPublicKey publicKey;
  final RSAPrivateKey privateKey;

  RSAKeyPair({
    required this.publicKey,
    required this.privateKey,
  });
}
