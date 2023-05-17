import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/device_consent.dart';

void main() {
  group('CreateDeviceConsentRequest', () {
    test('fromJson/toJson - Normal', () {
      final Map<String, dynamic> jsonData = {
        "event_type": "APPROVED",
        "confirmed_at": "2023-06-01T00:00:00.000Z",
      };

      // Test fromJson
      final request = CreateDeviceConsentRequest.fromJson(jsonData);
      expect(request.eventType, DeviceConsentEventType.APPROVED);
      expect(request.confirmedAt, DateTime.parse("2023-06-01T00:00:00.000Z"));

      // Test toJson
      final toJsonResult = request.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromJson with invalid eventType - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "event_type": "INVALID",
        "confirmed_at": "2023-06-01T00:00:00.000Z",
      };

      final request = CreateDeviceConsentRequest.fromJson(jsonData);
      expect(request.eventType, DeviceConsentEventType.APPROVED);
    });

    test('fromJson with invalid date format - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "event_type": "APPROVED",
        "confirmed_at": "invalid date",
      };

      expect(() => CreateDeviceConsentRequest.fromJson(jsonData),
          throwsFormatException);
    });
  });

  group('CreateDeviceConsentResponse', () {
    test('fromJson/toJson - Normal', () {
      final Map<String, dynamic> jsonData = {
        "id": "consent_123",
        "person_id": "person_123",
        "event_type": "APPROVED",
        "confirmed_at": "2023-06-01T00:00:00.000Z",
        "created_at": "2023-06-01T00:00:00.000Z",
      };

      // Test fromJson
      final response = CreateDeviceConsentResponse.fromJson(jsonData);
      expect(response.id, "consent_123");
      expect(response.personId, "person_123");
      expect(response.eventType, DeviceConsentEventType.APPROVED);
      expect(response.confirmedAt, DateTime.parse("2023-06-01T00:00:00.000Z"));
      expect(response.createdAt, DateTime.parse("2023-06-01T00:00:00.000Z"));

      // Test toJson
      final toJsonResult = response.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromJson with invalid eventType - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "id": "consent_123",
        "person_id": "person_123",
        "event_type": "INVALID",
        "confirmed_at": "2023-06-01T00:00:00.000Z",
        "created_at": "2023-06-01T00:00:00.000Z",
      };

      final response = CreateDeviceConsentResponse.fromJson(jsonData);
      expect(response.eventType, DeviceConsentEventType.APPROVED);
    });

    test('fromJson with invalid date format - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "id": "consent_123",
        "person_id": "person_123",
        "event_type": "APPROVED",
        "confirmed_at": "invalid date",
        "created_at": "invalid date",
      };

      expect(() => CreateDeviceConsentResponse.fromJson(jsonData),
          throwsFormatException);
    });
  });
}
