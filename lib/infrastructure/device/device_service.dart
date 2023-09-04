import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/utilities/crypto/crypto_message_signer.dart';

MethodChannel _platform = const MethodChannel('com.thinslices.solarisdemo/native');

const deviceIdKey = 'device_id';
const deviceConsentIdKey = 'device_consent_id';
const getDeviceFingerprintMethod = 'getDeviceFingerprint';
const getIosDeviceFingerprintMethod = 'getIosDeviceFingerprint';

class DeviceService {
  DeviceService();

  Future<String?> getConsentId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getString(deviceConsentIdKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getDeviceId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(deviceIdKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getDeviceFingerprint(String consentId) async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        return _platform.invokeMethod(
          getDeviceFingerprintMethod,
          {'consentId': consentId},
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await _platform.invokeMethod(
          getIosDeviceFingerprintMethod,
          {'consentId': consentId},
        );
      }

      return null;
    } catch (e) {
      return null;
    }
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

  String? generateSignature({required String privateKey, required String stringToSign}) {
    try {
      return CryptoMessageSigner.signMessage(message: stringToSign, encodedPrivateKey: privateKey);
    } catch (e) {
      return null;
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
