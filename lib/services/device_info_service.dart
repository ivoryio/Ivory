import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceInfoService {
  static getDeviceSignature(String consentId) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      _getAndroidDeviceSignature(consentId);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      _getIosDeviceSignature(consentId);
    }

    return null;
  }
}

MethodChannel _platform =
    const MethodChannel('com.thinslices.solarisdemo/native');

Future<void> _getAndroidDeviceSignature(String deviceConsentId) async {
  try {
    final result = await _platform.invokeMethod(
      'getDeviceFingerprint',
      {'consentId': deviceConsentId},
    );
    log("iOS Device Signature: $result");

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
    log("Android Device Signature: $result");

    return result;
  } on PlatformException catch (e) {
    log('Error: ${e.message}');
  }
}
