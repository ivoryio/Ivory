import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jose/jose.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/crypto/jwk.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/utilities/crypto/crypto_key_generator.dart';
import 'package:solarisdemo/utilities/crypto/crypto_message_signer.dart';
import 'package:solarisdemo/utilities/crypto/crypto_utils.dart';

MethodChannel _platform = const MethodChannel('com.thinslices.solarisdemo/native');

const deviceIdKey = 'device_id';
const consentIdsKey = 'consents';
const encryptPinMethod = 'encryptPin';

class DeviceService {
  DeviceService();

  Future<String?> getConsentId(String personId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? consentsJson = prefs.getString('consents');

      if (consentsJson == null) return null;
      Map<String, String> consents = Map<String, String>.from(json.decode(consentsJson));

      return consents[personId];
    } catch (e) {
      return null;
    }
  }

  Future<void> saveConsentIdInCache(String consentId, String personId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> consents = Map<String, String>.from(json.decode(prefs.getString(consentIdsKey) ?? '{}'));

    consents[personId] = consentId;
    await prefs.setString(consentIdsKey, json.encode(consents));
  }

  Future<String?> getDeviceId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(deviceIdKey) ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<void> saveDevicePairingTriedAt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('device_pairing_tried_at', DateTime.now().millisecondsSinceEpoch);
  }

  Future<int?> getDevicePairingTriedAt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('device_pairing_tried_at');
  }

  Future<String?> encryptPin({required String pinToEncrypt, required Map<String, dynamic> pinKey}) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return _platform.invokeMethod(
          encryptPinMethod,
          {'pinKey': pinKey, 'pinToEncrypt': pinToEncrypt},
        );
      } else {
        return _platform.invokeMethod(
          encryptPinMethod,
          {'pinKey': jsonEncode(pinKey), 'pinToEncrypt': pinToEncrypt},
        );
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> saveKeyPairIntoCache({
    required DeviceKeyPairs keyPair,
    bool restricted = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> keypair = {
      'publicKey': keyPair.publicKey,
      'privateKey': keyPair.privateKey,
    };

    String keyPairData = json.encode(keypair);

    prefs.setString(
      restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair',
      keyPairData,
    );
  }

  Future<void> saveDeviceIdIntoCache(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('device_id', deviceId);
  }

  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? keyPairData = prefs.getString(restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair');
      if (keyPairData != null) {
        Map<String, dynamic> keyPairObject = json.decode(keyPairData);

        return DeviceKeyPairs(
          publicKey: keyPairObject['publicKey'] ?? '',
          privateKey: keyPairObject['privateKey'] ?? '',
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveCredentialsInCache(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('email', email);
      prefs.setString('password', password);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<CacheCredentials?> getCredentialsFromCache() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? email = prefs.getString('email');
      String? password = prefs.getString('password');
      String? deviceId = await getDeviceId();

      return CacheCredentials(
        email: email,
        password: password,
        deviceId: deviceId,
      );
    } catch (e) {
      return null;
    }
  }

  String? generateSignature({required String privateKey, required String stringToSign}) {
    try {
      return CryptoMessageSigner.signMessage(message: stringToSign, encodedPrivateKey: privateKey);
    } catch (e) {
      return null;
    }
  }

  DeviceKeyPairs? generateECKey() {
    try {
      var newKeyPair = CryptoKeyGenerator.generateECKeyPair();
      return DeviceKeyPairs(
        publicKey: newKeyPair.publicKey,
        privateKey: newKeyPair.privateKey,
      );
    } catch (e) {
      return null;
    }
  }

  RSAKeyPair? generateRSAKey() {
    try {
      return CryptoKeyGenerator.generateRSAKeyPair();
    } catch (e) {
      return null;
    }
  }

  Jwk? convertRSAPublicKeyToJWK({required RSAPublicKey rsaPublicKey}) {
    try {
      return CryptoUtils.convertRSAPublicKeyToJWK(rsaPublicKey: rsaPublicKey);
    } catch (e) {
      return null;
    }
  }

  Future<BankCardFetchedDetails> decryptCardDetails({
    required String encodedJwe,
    required RSAPrivateKey privateKey,
    required RSAPublicKey publicKey,
  }) async {
    try {
      final jwe = JsonWebEncryption.fromCompactSerialization(encodedJwe);
      final jwk = JsonWebKey.rsa(
        modulus: privateKey.modulus!,
        exponent: publicKey.exponent!,
        privateExponent: privateKey.privateExponent!,
        firstPrimeFactor: privateKey.p,
        secondPrimeFactor: privateKey.q,
      );
      final keyStore = JsonWebKeyStore()..addKey(jwk);
      final payload = await jwe.getPayload(keyStore);
      final payloadString = utf8.decode(payload.data);
      final json = jsonDecode(payloadString);

      return BankCardFetchedDetails(
        cardHolder: json?['line_1'] ?? "",
        cardExpiry: json?['expires_at'] ?? "",
        cvv: json?["cvc"] ?? "",
        cardNumber: json?["pan"] ?? "",
      );
    } catch (error) {
      print("decryptJwe error: $error");
      rethrow;
    }
  }
}

class DeviceKeyPairs {
  final String publicKey;
  final String privateKey;

  DeviceKeyPairs({
    required this.publicKey,
    required this.privateKey,
  });
}
