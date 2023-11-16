import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceInfoService();

  Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
        String manufacturer = androidInfo.manufacturer;
        String model = androidInfo.model;
        String response = '$manufacturer $model';
        if (response.length > 20) {
          return response.substring(0, 20);
        }

        return response.substring(0, response.length);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.name;
      }
      return 'Unknown device';
    } catch (e) {
      debugPrint(e.toString());
      return 'Unknown device';
    }
  }
}
