import 'package:solarisdemo/models/device_activity.dart';
import 'package:test/test.dart';

void main() {
  group('CreateDeviceActivityRequest', () {
    test('fromJson/toJson', () {
      final Map<String, dynamic> jsonData = {
        "device_data": "device123",
        "activity_type": "APP_START",
      };

      // Test fromJson
      final request = CreateDeviceActivityRequest.fromJson(jsonData);
      expect(request.deviceData, "device123");
      expect(request.activityType, DeviceActivityType.APP_START);

      // Test toJson
      final toJsonResult = request.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromJson with invalid activity type - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "device_data": "device123",
        "activity_type": "INVALID_TYPE",
      };

      final request = CreateDeviceActivityRequest.fromJson(jsonData);
      expect(request.deviceData, "device123");
      expect(request.activityType, DeviceActivityType.APP_START);
    });
  });

  group('getActivityType()', () {
    test('getActivityType', () {
      expect(getActivityType("APP_START"), DeviceActivityType.APP_START);
      expect(
          getActivityType("PASSWORD_RESET"), DeviceActivityType.PASSWORD_RESET);
      expect(getActivityType("CONSENT_PROVIDED"),
          DeviceActivityType.CONSENT_PROVIDED);
    });

    test('getActivityType() - Invalid activity type', () {
      expect(getActivityType("INVALID_TYPE"), DeviceActivityType.APP_START);
    });
  });
}
