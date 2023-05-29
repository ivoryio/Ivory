// ignore_for_file: constant_identifier_names

import 'dart:convert';

enum DeviceActivityType {
  APP_START,
  PASSWORD_RESET,
  CONSENT_PROVIDED,
}

CreateDeviceActivityRequest createDeviceActivityRequestFromJson(String str) =>
    CreateDeviceActivityRequest.fromJson(json.decode(str));

String createDeviceActivityRequestToJson(CreateDeviceActivityRequest data) =>
    json.encode(data.toJson());

class CreateDeviceActivityRequest {
  String deviceData;
  DeviceActivityType activityType;

  CreateDeviceActivityRequest({
    required this.deviceData,
    required this.activityType,
  });

  factory CreateDeviceActivityRequest.fromJson(Map<String, dynamic> json) =>
      CreateDeviceActivityRequest(
        deviceData: json["device_data"],
        activityType: getActivityType(json["activity_type"]),
      );

  Map<String, dynamic> toJson() => {
        "device_data": deviceData,
        "activity_type": activityType.name,
      };
}

DeviceActivityType getActivityType(String type) {
  switch (type) {
    case 'APP_START':
      return DeviceActivityType.APP_START;
    case 'PASSWORD_RESET':
      return DeviceActivityType.PASSWORD_RESET;
    case 'CONSENT_PROVIDED':
      return DeviceActivityType.CONSENT_PROVIDED;
    default:
      return DeviceActivityType.APP_START;
  }
}
