import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_consent.dart';

import '../models/device_activity.dart';
import 'api_service.dart';

MethodChannel _platform =
    const MethodChannel('com.thinslices.solarisdemo/native');

class DeviceUtilService {
  static getDeviceSignature(String consentId) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidDeviceSignature(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosDeviceSignature(consentId);
    }
  }

  static getECDSAP256KeyPair() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _getAndroidECDSAP256KeyPair();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _getIosECDSAP256KeyPair();
    }
    return null;
  }

  static signMessage(String message, String privateKey) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _signMessageOnAndroid(message, privateKey);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _signMessageOnIos(message, privateKey);
    }
  }

  static Future<String?> getDeviceConsentId() async {
    return await _getDeviceConsentId();
  }

  static Future<void> saveDeviceConsentId(String consentId) async {
    await _setDeviceConsentId(consentId);
  }
}

Future<void> _getAndroidDeviceSignature(String deviceConsentId) async {
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

Future<void> _getIosDeviceSignature(String deviceConsentId) async {
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
  // log('getDeviceConsentId $deviceConsentId');
  return deviceConsentId ?? '';
}

Future<void> _setDeviceConsentId(String deviceConsentId) async {
  // log('setDeviceConsentId $deviceConsentId');
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
      log(e.toString());
      throw Exception("Failed to load device consent");
    }
  }

  Future<dynamic> createDeviceActivity(DeviceActivityType activityType) async {
    try {
      String path = 'person/device/activity';

      String? consentId = await _getDeviceConsentId();
      String deviceFingerprint =
          await DeviceUtilService.getDeviceSignature(consentId);
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
}
