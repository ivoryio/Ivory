import 'dart:convert';

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
  String key;
  String keyType;
  String keyPurpose;
  DeviceSignature deviceSignature;
  String deviceData;

  CreateRestrictedKeyRequest({
    required this.key,
    required this.keyType,
    required this.keyPurpose,
    required this.deviceSignature,
    required this.deviceData,
  });

  factory CreateRestrictedKeyRequest.fromJson(Map<String, dynamic> json) =>
      CreateRestrictedKeyRequest(
        key: json["key"],
        keyType: json["key_type"],
        keyPurpose: json["key_purpose"],
        deviceSignature: DeviceSignature.fromJson(json["device_signature"]),
        deviceData: json["device_data"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "key_type": keyType,
        "key_purpose": keyPurpose,
        "device_signature": deviceSignature.toJson(),
        "device_data": deviceData,
      };
}

class DeviceSignature {
  String signatureKeyPurpose;
  String signature;

  DeviceSignature({
    required this.signatureKeyPurpose,
    required this.signature,
  });

  factory DeviceSignature.fromJson(Map<String, dynamic> json) =>
      DeviceSignature(
        signatureKeyPurpose: json["signature_key_purpose"],
        signature: json["signature"],
      );

  Map<String, dynamic> toJson() => {
        "signature_key_purpose": signatureKeyPurpose,
        "signature": signature,
      };
}
