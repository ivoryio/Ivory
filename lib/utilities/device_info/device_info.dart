import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  static DeviceInfo? _instance;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceInfo._();

  static DeviceInfo get instance {
    _instance ??= DeviceInfo._();
    return _instance!;
  }

  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      String manufacturer = androidInfo.manufacturer;
      String model = androidInfo.model;
      return '$manufacturer $model'.substring(0, 20);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      return iosInfo.name;
    }
    return 'Unknown';
  }
}
