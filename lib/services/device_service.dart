import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_binding.dart';
import 'package:solarisdemo/models/device_consent.dart';

import '../models/device_activity.dart';
import 'api_service.dart';

const String _defaultKeyType = 'ecdsa-p256';
const String _defaultChallengeType = 'string';
const DeviceBindingKeyPurposeType _defaultKeyPurposeType =
    DeviceBindingKeyPurposeType.unrestricted;
SmsChallenge _defaultSmsChallenge = SmsChallenge(appSignature: 'e2e-e2e-e2e');
const DeviceBindingLanguageType _defaultLanguageType =
    DeviceBindingLanguageType.en;

MethodChannel _platform =
    const MethodChannel('com.thinslices.solarisdemo/native');

class DeviceUtilService {
  static getDeviceFingerprint(String consentId) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidDeviceFingerprint(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosDeviceFingerprint(consentId);
    }
  }

  static getECDSAP256KeyPair() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidECDSAP256KeyPair();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosECDSAP256KeyPair();
    }
    return null;
  }

  static signMessage(String message, String privateKey) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _signMessageOnAndroid(message, privateKey);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _signMessageOnIos(message, privateKey);
    }
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

  static Future<void> saveKeyPairIntoCache(dynamic keyPair) async {
    await _setKeyPairIntoCache(keyPair);
  }

  static Future<String?> getDeviceIdFromCache() async {
    return await _getDeviceIdFromCache();
  }

  static Future<void> saveDeviceIdIntoCache(String deviceId) async {
    await _setDeviceIdIntoCache(deviceId);
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

Future<dynamic> _getPublicKeyFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? publicKey = prefs.getString('publicKey');
  // log('getDeviceConsentId $deviceConsentId');
  return publicKey ?? '';
}

Future<dynamic> _getPrivateKeyFromCache() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? privateKey = prefs.getString('privateKey');
  // log('getDeviceConsentId $deviceConsentId');
  return privateKey ?? '';
}

Future<void> _setKeyPairIntoCache(dynamic keyPair) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('publicKey', keyPair['publicKey']);
  prefs.setString('privateKey', keyPair['privateKey']);
}

Future<void> _getAndroidDeviceFingerprint(String deviceConsentId) async {
  try {
    final result = await _platform.invokeMethod(
      'getDeviceFingerprint',
      {'consentId': deviceConsentId},
    );
    // log("Android Device Signature: $result");
    return result;
  } on PlatformException catch (e) {
    log('Error: ${e.message}');
  }
}

Future<void> _getIosDeviceFingerprint(String deviceConsentId) async {
  try {
    final result = await _platform.invokeMethod(
      'getIosDeviceFingerprint',
      {'consentId': deviceConsentId},
    );
    // log("IOS Device Signature: $result");
    return result;
  } on PlatformException catch (e) {
    log('Error: ${e.message}');
  }
}

Future<void> _getAndroidECDSAP256KeyPair() async {
  try {
    final result = await _platform.invokeMethod(
      'generateECDSAP256KeyPair',
    );
    log('$result');
    // log(result['publicKey']);

    return result;
  } on PlatformException catch (e) {
    log('Error: ${e.message}');
  }
}

Future<void> _getIosECDSAP256KeyPair() async {
  try {
    final result = await _platform.invokeMethod(
      'generateIosECDSAP256KeyPair',
    );
    inspect(result);

    return result;
  } on PlatformException catch (e) {
    log('Error: ${e.message}');
  }
}

Future<void> _signMessageOnAndroid(String message, String privateKey) async {
  try {
    final signature = await _platform.invokeMethod<String>(
      'signMessage',
      {'message': message, 'privateKey': privateKey},
    );
    print('Signature: $signature');
  } on PlatformException catch (e) {
    print('Error: ${e.message}');
  }
}

Future<void> _signMessageOnIos(String message, String privateKey) async {
  try {
    final signature = await _platform.invokeMethod<String>(
      'signMessage',
      {'message': message, 'privateKey': privateKey},
    );
    print('Signature: $signature');
  } on PlatformException catch (e) {
    print('Error: ${e.message}');
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

      var data = await post(
        path,
        body: CreateDeviceConsentRequest(
          confirmedAt: DateTime.now(),
          eventType: DeviceConsentEventType.APPROVED,
        ).toJson(),
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
      String deviceFingerprint =
          await DeviceUtilService.getDeviceFingerprint(consentId);
      var data = await post(
        path,
        body: CreateDeviceActivityRequest(
          activityType: activityType,
          deviceData: deviceFingerprint,
        ).toJson(),
      );
      if (data['success'] == true) {
        log('Activity $activityType.name created successfully');
      }
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
      //Generate key
      var keyPair = DeviceUtilService.getECDSAP256KeyPair();
      DeviceUtilService.saveKeyPairIntoCache(keyPair);

      String publicKey = keyPair['publicKey'];
      String deviceData =
          await DeviceUtilService.getDeviceFingerprint(consentId);
      var data = await post(
        path,
        body: CreateDeviceBindingRequest(
                personId: personId,
                keyType: _defaultKeyType,
                challengeType: _defaultChallengeType,
                key: publicKey,
                keyPurpose: _defaultKeyPurposeType,
                name: 'Test Device',
                smsChallenge: _defaultSmsChallenge,
                language: _defaultLanguageType,
                deviceData: deviceData)
            .toJson(),
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

      String? signature = await DeviceUtilService.signMessage(tan, privateKey);

      String path = 'person/device/verify_signature/$deviceId';
      String deviceFingerPrint =
          await DeviceUtilService.getDeviceFingerprint(consentId);

      var data = await post(path,
          body: VerifyDeviceSignatureChallengeRequest(
            deviceData: deviceFingerPrint,
            signature: signature!,
          ).toJson());
    } catch (e) {
      throw Exception('Failed to verify device binding signature - $e');
    }
  }
}