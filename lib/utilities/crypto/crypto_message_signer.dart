import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';

class CryptoMessageSigner {
  static String signMessage(
      {required String message, required String encodedPrivateKey}) {
    final utf8EncodedMessage = utf8.encode(message);

    final bigIntPrivateKey = BigInt.parse(encodedPrivateKey, radix: 16);
    final privateKey = ECPrivateKey(bigIntPrivateKey, ECCurve_secp256r1());

    final ecSignature =
        _signUtf8MessageWithEcPrivateKey(privateKey, utf8EncodedMessage);
    return _convertSignatureToAsn1String(ecSignature);
  }

  static ECSignature _signUtf8MessageWithEcPrivateKey(
      ECPrivateKey privateKey, List<int> utf8EncodedMessage) {
    final signer = ECDSASigner(SHA256Digest());
    signer.init(true,
        ParametersWithRandom(PrivateKeyParameter(privateKey), _secureRandom()));
    final signedMessage =
        signer.generateSignature(Uint8List.fromList(utf8EncodedMessage))
            as ECSignature;
    return signedMessage;
  }

  static String _convertSignatureToAsn1String(ECSignature signature) {
    final asn1Sequence = ASN1Sequence();
    asn1Sequence.add(ASN1Integer(signature.r));
    asn1Sequence.add(ASN1Integer(signature.s));
    asn1Sequence.encode();
    final asn1Bytes = asn1Sequence.encodedBytes;
    return hex.encode(asn1Bytes!.toList());
  }

  static SecureRandom _secureRandom() {
    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }

    return FortunaRandom()..seed(KeyParameter(Uint8List.fromList(seeds)));
  }
}
