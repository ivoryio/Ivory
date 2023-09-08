import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  DeviceInfoService();


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
