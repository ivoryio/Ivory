// ignore_for_file: depend_on_referenced_packages

import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_binding.dart';
import 'package:solarisdemo/models/device_consent.dart';
import 'dart:convert';
import 'package:solarisdemo/utilities/crypto/crypto_message_signer.dart';

import '../models/device.dart';
import '../models/device_activity.dart';
import '../utilities/crypto/crypto_key_generator.dart';
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

  static Future<String?> getDeviceConsentId() async {
    return await _getDeviceConsentId();
  }

  static Future<void> saveDeviceConsentId(String consentId) async {
    await _setDeviceConsentId(consentId);
  }

  static Future<String?> getPublicKeyFromCache({
    bool restricted = false,
  }) async {
    return await _getPublicKeyFromCache(
      restricted: restricted,
    );
  }

  static Future<String?> getPrivateKeyFromCache({
    bool restricted = false,
  }) async {
    return await _getPrivateKeyFromCache(
      restricted: restricted,
    );
  }

  static Future<void> saveKeyPairIntoCache({
    required CryptoKeyPair keyPair,
    bool restricted = false,
  }) async {
    await _setKeyPairIntoCache(
      keyPair: keyPair,
      restricted: restricted,
    );
  }

  static Future<String?> getDeviceIdFromCache() async {
    return await _getDeviceIdFromCache();
  }

  static Future<void> saveDeviceIdIntoCache(String deviceId) async {
    await setDeviceIdIntoCache(deviceId);
  }

  static Future<CacheCredentials?> getCredentialsFromCache() async {
    return await _getCredentialsFromCache();
  }

  static Future<void> saveCredentialsInCache(
      String email, String password) async {
    await _setCredentialsInCache(email, password);
  }
}

Future<void> setDeviceIdIntoCache(String deviceId) async {
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

Future<String> _getPublicKeyFromCache({
  bool restricted = false,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? keyPairData =
      prefs.getString(restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair');
  if (keyPairData != null) {
    Map<String, dynamic> keyPairObject = json.decode(keyPairData);
    return keyPairObject['publicKey'] ?? '';
  }

  return '';
}

Future<String> _getPrivateKeyFromCache({
  bool restricted = false,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? keyPairData =
      prefs.getString(restricted ? 'restrictedKeyPair' : 'unrestrictedKeyPair');
  if (keyPairData != null) {
    Map<String, dynamic> keyPairObject = json.decode(keyPairData);
    return keyPairObject['privateKey'] ?? '';
  }

  return '';
}

Future<void> _setKeyPairIntoCache({
  required CryptoKeyPair keyPair,
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

      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();
      final keyPair = keyGenerator.generateECKeyPair();

      await DeviceUtilService.saveKeyPairIntoCache(
        keyPair: keyPair,
      );

      String publicKey = keyPair.publicKey;

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
      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      final signature = messageSigner.signMessage(
        message: tan,
        encodedPrivateKey: privateKey,
      );

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

  Future<dynamic> createRestrictedKey() async {
    try {
      CryptoMessageSigner messageSigner = CryptoMessageSigner();
      CryptoKeyGenerator keyGenerator = CryptoKeyGenerator();

      String? deviceId = await DeviceUtilService.getDeviceIdFromCache();
      if (deviceId == null) {
        throw Exception('Device Id not found');
      }
      var newKeyPair = keyGenerator.generateECKeyPair();
      String newPublicKey = newKeyPair.publicKey;

      String? oldPrivateKey = await DeviceUtilService.getPrivateKeyFromCache();

      if (oldPrivateKey == null) {
        throw Exception('Public/private key not found');
      }

      final signature = messageSigner.signMessage(
        message: newPublicKey,
        encodedPrivateKey: oldPrivateKey,
      );

      String? consentId = await _getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      String? deviceFingerprint =
          await DeviceUtilService.getDeviceFingerprint(consentId);

      CreateRestrictedKeyRequest reqBody = CreateRestrictedKeyRequest(
        deviceId: deviceId,
        deviceData: deviceFingerprint!,
        deviceSignature: DeviceSignature(
          signature: signature,
          signatureKeyPurpose: DeviceBindingKeyPurposeType.unrestricted,
        ),
        key: newPublicKey,
        keyPurpose: DeviceBindingKeyPurposeType.restricted,
        keyType: _defaultKeyType,
      );

      String path = 'person/device/key';

      await post(
        path,
        body: reqBody.toJson(),
      );

      await DeviceUtilService.saveKeyPairIntoCache(
        keyPair: newKeyPair,
        restricted: true,
      );
    } catch (e) {
      throw Exception('Failed to create restricted key - $e');
    }
  }
}

class CacheCardsIds {
  static Future<void> saveCardIdToCache(String cardIdToStore) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardIdsList = prefs.getStringList('ids');

    cardIdsList ??= [];
    cardIdsList.add(cardIdToStore);

    await prefs.setStringList('ids', cardIdsList);
  }

  static Future<bool> getCardIdFromCache(String cardIdToFind) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cardIdsList = prefs.getStringList('ids');
    // prefs.clear();

    if (cardIdsList == null) {
      return false;
    }

    bool containsId = cardIdsList.contains(cardIdToFind);

    return containsId;
  }
}
