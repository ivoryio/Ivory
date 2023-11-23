import 'dart:convert';

enum DeviceBindingKeyPurposeType {
  restricted,
  unrestricted,
}

enum DeviceBindingLanguageType {
  en,
  de,
  fr,
}

const String _defaultKeyType = 'ecdsa-p256';
const String _defaultChallengeType = 'sms';
const DeviceBindingLanguageType _defaultLanguageType = DeviceBindingLanguageType.en;
SmsChallenge _defaultSmsChallenge = SmsChallenge(appSignature: 'e2e-e2e-e2e');

String addRestrictedKeyRequestToJson(CreateRestrictedKeyRequest data) => json.encode(data.toJson());

class CreateRestrictedKeyRequest {
  String deviceId;
  String key;
  String keyType;
  DeviceBindingKeyPurposeType keyPurpose;
  DeviceSignature deviceSignature;
  String deviceData;

  CreateRestrictedKeyRequest({
    required this.deviceId,
    required this.key,
    required this.deviceSignature,
    required this.deviceData,
  })  : keyType = _defaultKeyType,
        keyPurpose = DeviceBindingKeyPurposeType.restricted;

  Map<String, dynamic> toJson() => {
        "device_id": deviceId,
        "key": key,
        "key_type": keyType,
        "key_purpose": keyPurpose.name,
        "device_signature": deviceSignature.toJson(),
        "device_data": deviceData,
      };
}

class DeviceSignature {
  DeviceBindingKeyPurposeType signatureKeyPurpose;
  String signature;

  DeviceSignature({
    this.signatureKeyPurpose = DeviceBindingKeyPurposeType.unrestricted,
    required this.signature,
  });

  Map<String, dynamic> toJson() => {
        "signature_key_purpose": signatureKeyPurpose.name,
        "signature": signature,
      };
}

DeviceBindingKeyPurposeType getKeyPurposeType(String type) {
  switch (type) {
    case 'restricted':
      return DeviceBindingKeyPurposeType.restricted;
    case 'unrestricted':
      return DeviceBindingKeyPurposeType.unrestricted;
    default:
      return DeviceBindingKeyPurposeType.unrestricted;
  }
}

String createDeviceBindingRequestToJson(CreateDeviceBindingRequest data) => json.encode(data.toJson());

class CreateDeviceBindingRequest {
  String personId;
  String keyType;
  String challengeType;
  String key;
  DeviceBindingKeyPurposeType keyPurpose;
  String name;
  SmsChallenge smsChallenge;
  DeviceBindingLanguageType language;
  String deviceData;

  CreateDeviceBindingRequest({
    required this.personId,
    required this.key,
    required this.name,
    required this.deviceData,
  })  : keyType = _defaultKeyType,
        challengeType = _defaultChallengeType,
        keyPurpose = DeviceBindingKeyPurposeType.unrestricted,
        smsChallenge = _defaultSmsChallenge,
        language = _defaultLanguageType;

  Map<String, dynamic> toJson() => {
        "person_id": personId,
        "key_type": keyType,
        "challenge_type": challengeType,
        "key": key,
        "key_purpose": keyPurpose.name,
        "name": name,
        "sms_challenge": smsChallenge.toJson(),
        "language": language.name,
        "device_data": deviceData,
      };
}

class SmsChallenge {
  String appSignature;

  SmsChallenge({
    required this.appSignature,
  });

  Map<String, dynamic> toJson() => {
        "app_signature": appSignature,
      };
}

DeviceBindingLanguageType getLanguageType(String type) {
  switch (type) {
    case 'en':
      return DeviceBindingLanguageType.en;
    case 'de':
      return DeviceBindingLanguageType.de;
    case 'fr':
      return DeviceBindingLanguageType.fr;
    default:
      return DeviceBindingLanguageType.en;
  }
}

CreateDeviceBindingChallenge createDeviceBindingResponseFromJson(String str) =>
    CreateDeviceBindingChallenge.fromJson(json.decode(str));

class CreateDeviceBindingChallenge {
  String id;
  Challenge challenge;

  CreateDeviceBindingChallenge({
    required this.id,
    required this.challenge,
  });

  factory CreateDeviceBindingChallenge.fromJson(Map<String, dynamic> json) => CreateDeviceBindingChallenge(
        id: json["id"],
        // keyId: json["key_id"],
        challenge: Challenge.fromJson(json["challenge"]),
      );
}

class Challenge {
  String id;
  String type;
  DateTime createdAt;
  DateTime expiresAt;

  Challenge({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.expiresAt,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json["id"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        expiresAt: DateTime.parse(json["expires_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "expires_at": expiresAt.toIso8601String(),
      };
}

String verifyDeviceSignatureChallengeRequestToJson(VerifyDeviceSignatureChallengeRequest data) =>
    json.encode(data.toJson());

class VerifyDeviceSignatureChallengeRequest {
  String signature;
  String deviceData;

  VerifyDeviceSignatureChallengeRequest({
    required this.signature,
    required this.deviceData,
  });

  Map<String, dynamic> toJson() => {
        "signature": signature,
        "device_data": deviceData,
      };
}

enum DeviceBindingServiceErrorType {
  unknown,
  getDeviceBindingFailed,
  deviceBindingFailed,
  verifyDeviceBindingSignatureFailed,
  createRestrictedKeyFailed,
  deletingDeviceBindingFailed
}

class Device {
  final String deviceId;
  final String deviceName;

  Device({required this.deviceId, required this.deviceName});

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        deviceId: json['id'],
        deviceName: json['name'],
      );
}
