import 'dart:convert';

import 'device_binding.dart';

CreateDeviceReqBody createDeviceFromJson(String str) =>
    CreateDeviceReqBody.fromJson(json.decode(str));

String createDeviceToJson(CreateDeviceReqBody data) =>
    json.encode(data.toJson());

class CreateDeviceReqBody {
  // String number;
  String deviceData;

  CreateDeviceReqBody({
    // required this.number,
    required this.deviceData,
  });

  factory CreateDeviceReqBody.fromJson(Map<String, dynamic> json) =>
      CreateDeviceReqBody(
        // number: json["number"],
        deviceData: json["device_data"],
      );

  Map<String, dynamic> toJson() => {
        // "number": number,
        "device_data": deviceData,
      };
}

CreateRestrictedKeyRequest addRestrictedKeyRequestFromJson(String str) =>
    CreateRestrictedKeyRequest.fromJson(json.decode(str));

String addRestrictedKeyRequestToJson(CreateRestrictedKeyRequest data) =>
    json.encode(data.toJson());

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
    required this.keyType,
    required this.keyPurpose,
    required this.deviceSignature,
    required this.deviceData,
  });

  factory CreateRestrictedKeyRequest.fromJson(Map<String, dynamic> json) =>
      CreateRestrictedKeyRequest(
        deviceId: json["device_id"],
        key: json["key"],
        keyType: json["key_type"],
        keyPurpose: getKeyPurposeType(json["key_purpose"]),
        deviceSignature: DeviceSignature.fromJson(json["device_signature"]),
        deviceData: json["device_data"],
      );

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
    required this.signatureKeyPurpose,
    required this.signature,
  });

  factory DeviceSignature.fromJson(Map<String, dynamic> json) =>
      DeviceSignature(
        signatureKeyPurpose: getKeyPurposeType(json["signature_key_purpose"]),
        signature: json["signature"],
      );

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
