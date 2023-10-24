// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_consent.dart';
import 'package:solarisdemo/models/user.dart';
import '../models/device_activity.dart';
import 'api_service.dart';

MethodChannel _platform = const MethodChannel('com.thinslices.solarisdemo/native');

class OldDeviceService extends ApiService {
  OldDeviceService({required super.user});

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

      String? consentId = await getDeviceConsentId();
      if (consentId.isEmpty) {
        throw Exception('Consent Id not found');
      }

      String? deviceFingerprint =
          await getDeviceFingerprint(consentId);
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

static Future<String?> getDeviceFingerprint(String consentId) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _getAndroidDeviceFingerprint(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _getIosDeviceFingerprint(consentId);
    }
    return '';
  }

  static Future<String> getDeviceConsentId() async {
    return await _getDeviceConsentId();
  }

  static Future<void> saveDeviceConsentId(String consentId) async {
    await _setDeviceConsentId(consentId);
  }

  static Future<String> getDeviceIdFromCache() async {
    return await _getDeviceIdFromCache();
  }

  static Future<CacheCredentials?> getCredentialsFromCache() async {
    return await _getCredentialsFromCache();
  }

  static Future<void> saveCredentialsInCache(String email, String password) async {
    await _setCredentialsInCache(email, password);
  }

  static Future<String> _getDeviceIdFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    return deviceId ?? '';
  }

  static Future<void> _setCredentialsInCache(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  static Future<CacheCredentials?> _getCredentialsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? deviceId = await _getDeviceIdFromCache();

    return CacheCredentials(
      email: email,
      password: password,
      deviceId: deviceId,
    );
  }

  static Future<String>? _getAndroidDeviceFingerprint(String deviceConsentId) async {
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

  static Future<String>? _getIosDeviceFingerprint(String deviceConsentId) async {
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

  static Future<String> _getDeviceConsentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceConsentId = prefs.getString('device_consent_id');
    return deviceConsentId ?? '';
  }

  static Future<void> _setDeviceConsentId(String deviceConsentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('device_consent_id', deviceConsentId);
  }
}
