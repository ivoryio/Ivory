import 'dart:math';

import 'package:flutter/services.dart';
import 'package:pointycastle/export.dart';

class CryptoKeyGenerator {
  CryptoKeyPair generateKeyPair() {
    var keyPair = _createKeyGenerator().generateKeyPair();
    var publicKeyUncompressedForm =
        _toUncompressedForm(keyPair.publicKey as ECPublicKey);

    var stop = false;
    var i = 0;
    while (i < 10 && stop != true) {
      if (publicKeyUncompressedForm.length % 2 != 0) {
        keyPair = _createKeyGenerator().generateKeyPair();
        publicKeyUncompressedForm =
            _toUncompressedForm(keyPair.publicKey as ECPublicKey);
        i++;
      } else {
        stop = true;
      }
    }
    return CryptoKeyPair(
      publicKey: publicKeyUncompressedForm,
      privateKey: _toHex(keyPair.privateKey as ECPrivateKey),
    );
  }

  ECKeyGenerator _createKeyGenerator() {
    final keyGen = ECKeyGenerator();

    keyGen.init(ParametersWithRandom(
        ECKeyGeneratorParameters(ECCurve_secp256r1()), _secureRandom()));
    return keyGen;
  }

  String _toUncompressedForm(ECPublicKey public) {
    final point = public.Q!;
    final x = point.x!.toBigInteger();
    final xHex = x!.toRadixString(16);
    final y = point.y!.toBigInteger();
    final yHex = y!.toRadixString(16);
    final encodedPublicKey = "04$xHex$yHex";
    return encodedPublicKey;
  }

  String _toHex(ECPrivateKey private) => private.d!.toRadixString(16);

  SecureRandom _secureRandom() {
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

  CryptoKeyPair({required this.publicKey, required this.privateKey});
}
