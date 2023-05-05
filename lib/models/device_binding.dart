import 'dart:convert';

CreateDeviceBindingRequest createDeviceBindingRequestFromJson(String str) =>
    CreateDeviceBindingRequest.fromJson(json.decode(str));

String createDeviceBindingRequestToJson(CreateDeviceBindingRequest data) =>
    json.encode(data.toJson());

enum DeviceBindingKeyPurposeType {
  restricted,
  unrestricted,
}

enum DeviceBindingLanguageType {
  en,
  de,
  fr,
}

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
    required this.keyType,
    required this.challengeType,
    required this.key,
    required this.keyPurpose,
    required this.name,
    required this.smsChallenge,
    required this.language,
    required this.deviceData,
  });

  factory CreateDeviceBindingRequest.fromJson(Map<String, dynamic> json) =>
      CreateDeviceBindingRequest(
        personId: json["person_id"],
        keyType: json["key_type"],
        challengeType: json["challenge_type"],
        key: json["key"],
        keyPurpose: getKeyPurposeType(json["key_purpose"]),
        name: json["name"],
        smsChallenge: SmsChallenge.fromJson(json["sms_challenge"]),
        language: getLanguageType(json["language"]),
        deviceData: json["device_data"],
      );

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

  factory SmsChallenge.fromJson(Map<String, dynamic> json) => SmsChallenge(
        appSignature: json["app_signature"],
      );

  Map<String, dynamic> toJson() => {
        "app_signature": appSignature,
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

CreateDeviceBindingResponse createDeviceBindingResponseFromJson(String str) =>
    CreateDeviceBindingResponse.fromJson(json.decode(str));

String createDeviceBindingResponseToJson(CreateDeviceBindingResponse data) =>
    json.encode(data.toJson());

class CreateDeviceBindingResponse {
  String id;
  String keyId;
  Challenge challenge;

  CreateDeviceBindingResponse({
    required this.id,
    required this.keyId,
    required this.challenge,
  });

  factory CreateDeviceBindingResponse.fromJson(Map<String, dynamic> json) =>
      CreateDeviceBindingResponse(
        id: json["id"],
        keyId: json["key_id"],
        challenge: Challenge.fromJson(json["challenge"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key_id": keyId,
        "challenge": challenge.toJson(),
      };
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

VerifyDeviceSignatureChallengeRequest verifyDeviceSignatureChallengeRequestFromJson(String str) => VerifyDeviceSignatureChallengeRequest.fromJson(json.decode(str));

String verifyDeviceSignatureChallengeRequestToJson(VerifyDeviceSignatureChallengeRequest data) => json.encode(data.toJson());

class VerifyDeviceSignatureChallengeRequest {
    String signature;
    String deviceData;

    VerifyDeviceSignatureChallengeRequest({
        required this.signature,
        required this.deviceData,
    });

    factory VerifyDeviceSignatureChallengeRequest.fromJson(Map<String, dynamic> json) => VerifyDeviceSignatureChallengeRequest(
        signature: json["signature"],
        deviceData: json["device_data"],
    );

    Map<String, dynamic> toJson() => {
        "signature": signature,
        "device_data": deviceData,
    };
}



