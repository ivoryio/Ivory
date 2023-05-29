import 'package:solarisdemo/models/device_binding.dart';
import 'package:test/test.dart';

void main() {
  group('CreateDeviceBindingRequest', () {
    test('fromJson/toJson - Normal', () {
      final Map<String, dynamic> jsonData = {
        "person_id": "person123",
        "key_type": "RSA",
        "challenge_type": "SMS",
        "key": "publickey",
        "key_purpose": "restricted",
        "name": "Device Name",
        "sms_challenge": {
          "app_signature": "App Signature",
        },
        "language": "en",
        "device_data": "device123",
      };

      // Test fromJson
      final request = CreateDeviceBindingRequest.fromJson(jsonData);
      expect(request.personId, "person123");
      expect(request.keyType, "RSA");
      expect(request.challengeType, "SMS");
      expect(request.key, "publickey");
      expect(request.keyPurpose, DeviceBindingKeyPurposeType.restricted);
      expect(request.name, "Device Name");
      expect(request.smsChallenge.appSignature, "App Signature");
      expect(request.language, DeviceBindingLanguageType.en);
      expect(request.deviceData, "device123");

      // Test toJson
      final toJsonResult = request.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromJson with invalid keyPurpose and language type - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "person_id": "person123",
        "key_type": "RSA",
        "challenge_type": "SMS",
        "key": "publickey",
        "key_purpose": "INVALID_PURPOSE",
        "name": "Device Name",
        "sms_challenge": {
          "app_signature": "App Signature",
        },
        "language": "INVALID_LANGUAGE",
        "device_data": "device123",
      };

      final request = CreateDeviceBindingRequest.fromJson(jsonData);
      expect(request.personId, "person123");
      expect(request.keyType, "RSA");
      expect(request.challengeType, "SMS");
      expect(request.key, "publickey");
      expect(request.keyPurpose, DeviceBindingKeyPurposeType.unrestricted);
      expect(request.name, "Device Name");
      expect(request.smsChallenge.appSignature, "App Signature");
      expect(request.language, DeviceBindingLanguageType.en);
      expect(request.deviceData, "device123");
    });
  });

  group('CreateDeviceBindingResponse', () {
    test('fromJson/toJson - Normal', () {
      final Map<String, dynamic> jsonData = {
        "id": "bind_123",
        "challenge": {
          "id": "chal_123",
          "type": "SMS",
          "created_at": "2023-05-12T14:20:00.000Z",
          "expires_at": "2023-05-12T14:30:00.000Z",
        },
      };

      // Test fromJson
      final response = CreateDeviceBindingResponse.fromJson(jsonData);
      expect(response.id, "bind_123");
      expect(response.challenge.id, "chal_123");
      expect(response.challenge.type, "SMS");
      expect(response.challenge.createdAt,
          DateTime.parse("2023-05-12T14:20:00.000Z"));
      expect(response.challenge.expiresAt,
          DateTime.parse("2023-05-12T14:30:00.000Z"));

      // Test toJson
      final toJsonResult = response.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromJson with invalid date format - Edge Case', () {
      final Map<String, dynamic> jsonData = {
        "id": "bind_123",
        "key_id": "key_123",
        "challenge": {
          "id": "chal_123",
          "type": "SMS",
          "created_at": "invalid date",
          "expires_at": "invalid date",
        },
      };

      expect(() => CreateDeviceBindingResponse.fromJson(jsonData),
          throwsFormatException);
    });
  });

  group('VerifyDeviceSignatureChallengeRequest', () {
    test('fromJson/toJson - Normal', () {
      final Map<String, dynamic> jsonData = {
        "signature": "signature123",
        "device_data": "device123",
      };

      // Test fromJson
      final request = VerifyDeviceSignatureChallengeRequest.fromJson(jsonData);
      expect(request.signature, "signature123");
      expect(request.deviceData, "device123");

      // Test toJson
      final toJsonResult = request.toJson();
      expect(toJsonResult, jsonData);
    });
  });
}
