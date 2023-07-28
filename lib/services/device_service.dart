// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_binding.dart';
import 'package:solarisdemo/models/device_consent.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:pointycastle/export.dart';

import '../models/device_activity.dart';
import 'api_service.dart';

const String _defaultKeyType = 'ecdsa-p256';
const String _defaultChallengeType = 'sms';
const DeviceBindingKeyPurposeType _defaultKeyPurposeType =
    DeviceBindingKeyPurposeType.unrestricted;
SmsChallenge _defaultSmsChallenge = SmsChallenge(appSignature: 'e2e-e2e-e2e');
const DeviceBindingLanguageType _defaultLanguageType =
    DeviceBindingLanguageType.en;

MethodChannel _platform =
    const MethodChannel('com.thinslices.solarisdemo/native');

class DeviceUtilService {
  static Future<String?> getDeviceFingerprint(String consentId) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidDeviceFingerprint(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosDeviceFingerprint(consentId);
    }
    return '';
  }

  static Future<Map<Object?, Object?>> getECDSAP256KeyPair() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidECDSAP256KeyPair();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosECDSAP256KeyPair();
    }
    return {};
  }

  static Future<String?> getDeviceConsentId() async {
    return await _getDeviceConsentId();
  }

  static Future<void> saveDeviceConsentId(String consentId) async {
    await _setDeviceConsentId(consentId);
  }

  static Future<String?> getPublicKeyFromCache() async {
    return await _getPublicKeyFromCache();
  }

  static Future<String?> getPrivateKeyFromCache() async {
    return await _getPrivateKeyFromCache();
  }

  static Future<void> saveKeyPairIntoCache(
      Map<Object?, Object?> keyPair) async {
    await _setKeyPairIntoCache(keyPair);
  }

  static Future<String?> getDeviceIdFromCache() async {
    return await _getDeviceIdFromCache();
  }

  static Future<void> saveDeviceIdIntoCache(String deviceId) async {
    await _setDeviceIdIntoCache(deviceId);
  }

  static Future<CacheCredentials?> getCredentialsFromCache() async {
    return await _getCredentialsFromCache();
  }

  static Future<void> saveCredentialsInCache(
      String email, String password) async {
    await _setCredentialsInCache(email, password);
  }

  static String signMessage(String message, String encodedPrivateKey) {
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

  static String calculateSHA256(String message) {
    var bytes = utf8.encode(message);
    var sha256 = SHA256Digest();
    var digest = sha256.process(Uint8List.fromList(bytes));
    return hex.encode(digest);
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

Future<void> _setDeviceIdIntoCache(String deviceId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('device_id', deviceId);
}

Future<String?> _getDeviceIdFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? deviceId = prefs.getString('device_id');
  return deviceId ?? '';
}

Future<void> _setCredentialsInCache(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
  prefs.setString('password', password);
}

Future<CacheCredentials?> _getCredentialsFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
  String? email = prefs.getString('email');
  String? password = prefs.getString('password');
  String? deviceId = await _getDeviceIdFromCache();

  return CacheCredentials(
    email: email,
    password: password,
    deviceId: deviceId,
  );
}

class CacheCredentials {
  String? email;
  String? password;
  String? deviceId;

  CacheCredentials({
    required this.email,
    required this.password,
    required this.deviceId,
  });
}

Future<String> _getPublicKeyFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? publicKey = prefs.getString('publicKey');
  return publicKey ?? '';
}

Future<String> _getPrivateKeyFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? privateKey = prefs.getString('privateKey');
  return privateKey ?? '';
}

Future<void> _setKeyPairIntoCache(Map<Object?, Object?> keyPair) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('publicKey', keyPair['publicKey'] as String);
  prefs.setString('privateKey', keyPair['privateKey'] as String);
}

Future<String>? _getAndroidDeviceFingerprint(String deviceConsentId) async {
  try {
    final result = await _platform.invokeMethod(
      'getDeviceFingerprint',
      {'consentId': deviceConsentId},
    );
    return result;
  } on PlatformException catch (e) {
    throw Exception(e.message);
  }
}

Future<String>? _getIosDeviceFingerprint(String deviceConsentId) async {
  try {
    final result = await _platform.invokeMethod(
      'getIosDeviceFingerprint',
      {'consentId': deviceConsentId},
    );
    return result;
  } on PlatformException catch (e) {
    throw Exception(e.message);
  }
}

Future<Map<Object?, Object?>> _getAndroidECDSAP256KeyPair() async {
  try {
    final result = await _platform.invokeMethod(
      'generateECDSAP256KeyPair',
    );
    return result;
  } on PlatformException catch (e) {
    throw Exception(e.message);
  }
}

Future<Map<Object?, Object?>> _getIosECDSAP256KeyPair() async {
  try {
    final result = await _platform.invokeMethod(
      'generateIosECDSAP256KeyPair',
    );
    return result;
  } on PlatformException catch (e) {
    throw Exception(e.message);
  }
}

Future<String> _getDeviceConsentId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? deviceConsentId = prefs.getString('device_consent_id');
  return deviceConsentId ?? '';
}

Future<void> _setDeviceConsentId(String deviceConsentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('device_consent_id', deviceConsentId);
}

class DeviceService extends ApiService {
  DeviceService({required super.user});

  Future<CreateDeviceConsentResponse>? createDeviceConsent() async {
    try {
      String path = 'person/device/consent';

      CreateDeviceConsentRequest reqBody = CreateDeviceConsentRequest(
        confirmedAt: DateTime.now().toUtc(),
        eventType: DeviceConsentEventType.APPROVED,
      );

      Map<String, dynamic> req = reqBody.toJson();

      var data = await post(
        path,
        body: req,
      );
      return CreateDeviceConsentResponse.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load device consent");
    }
  }

  Future<dynamic> createDeviceActivity(DeviceActivityType activityType) async {
    try {
      String path = 'person/device/activity';

      String? consentId = await _getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      String? deviceFingerprint =
          await DeviceUtilService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null || deviceFingerprint.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      await post(
        path,
        body: CreateDeviceActivityRequest(
          activityType: activityType,
          deviceData: deviceFingerprint,
        ).toJson(),
      );
      return;
    } catch (e) {
      throw Exception("Failed to load device activity");
    }
  }

  Future<CreateDeviceBindingResponse> createDeviceBinding(
      String personId) async {
    try {
      String path = 'person/device/binding';

      String? consentId = await _getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      var keyPair = await DeviceUtilService.getECDSAP256KeyPair();
      if (keyPair.isEmpty) {
        throw Exception('Key Pair not found');
      }

      await DeviceUtilService.saveKeyPairIntoCache(keyPair);

      String publicKey = keyPair['publicKey'] as String;

      String? deviceData =
          await DeviceUtilService.getDeviceFingerprint(consentId);
      if (deviceData == null || deviceData.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      CreateDeviceBindingRequest reqBody = CreateDeviceBindingRequest(
        personId: personId,
        keyType: _defaultKeyType,
        challengeType: _defaultChallengeType,
        key: publicKey,
        keyPurpose: _defaultKeyPurposeType,
        name: 'Test Device',
        smsChallenge: _defaultSmsChallenge,
        language: _defaultLanguageType,
        deviceData: deviceData,
      );

      var data = await post(
        path,
        body: reqBody.toJson(),
      );
      var response = CreateDeviceBindingResponse.fromJson(data);
      await DeviceUtilService.saveDeviceIdIntoCache(response.id);
      return response;
    } catch (e) {
      throw Exception('Failed to create device binding - $e');
    }
  }

  Future<void> verifyDeviceBindingSignature(String tan) async {
    try {
      String? deviceId = await DeviceUtilService.getDeviceIdFromCache();
      if (deviceId == null) {
        throw Exception('Device Id not found');
      }

      String? consentId = await DeviceUtilService.getDeviceConsentId();
      if (consentId == null) {
        throw Exception('Consent Id not found');
      }

      String? privateKey = await DeviceUtilService.getPrivateKeyFromCache();
      if (privateKey == null) {
        throw Exception('Private key not found');
      }

      String? signature = DeviceUtilService.signMessage(tan, privateKey);

      String path = 'person/device/verify_signature/$deviceId';

      String? deviceFingerPrint =
          await DeviceUtilService.getDeviceFingerprint(consentId);
      if (deviceFingerPrint == null || deviceFingerPrint.isEmpty) {
        throw Exception('Device Fingerprint not found');
      }

      await post(
        path,
        body: VerifyDeviceSignatureChallengeRequest(
          deviceData: deviceFingerPrint,
          signature: signature,
        ).toJson(),
      );
    } catch (e) {
      throw Exception('Failed to verify device signature - $e');
    }
  }
}
