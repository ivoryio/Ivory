// ignore_for_file: constant_identifier_names

import 'dart:convert';

enum DeviceConsentEventType {
  APPROVED,
  REJECTED,
}

CreateDeviceConsentRequest createDeviceConsentRequestFromJson(String str) =>
    CreateDeviceConsentRequest.fromJson(json.decode(str));

String createDeviceConsentRequestToJson(CreateDeviceConsentRequest data) =>
    json.encode(data.toJson());

class CreateDeviceConsentRequest {
  DeviceConsentEventType eventType;
  DateTime confirmedAt;

  CreateDeviceConsentRequest({
    required this.eventType,
    required this.confirmedAt,
  });

  factory CreateDeviceConsentRequest.fromJson(Map<String, dynamic> json) =>
      CreateDeviceConsentRequest(
        eventType: getEventType(json["event_type"]),
        confirmedAt: DateTime.parse(json["confirmed_at"]),
      );

  Map<String, dynamic> toJson() => {
        "event_type": eventType.name,
        "confirmed_at": confirmedAt.toIso8601String(),
      };
}

DeviceConsentEventType getEventType(String type) {
  switch (type) {
    case 'APPROVED':
      return DeviceConsentEventType.APPROVED;
    case 'REJECTED':
      return DeviceConsentEventType.REJECTED;
    default:
      return DeviceConsentEventType.APPROVED;
  }
}

CreateDeviceConsentResponse createDeviceConsentResponseFromJson(String str) =>
    CreateDeviceConsentResponse.fromJson(json.decode(str));

String createDeviceConsentResponseToJson(CreateDeviceConsentResponse data) =>
    json.encode(data.toJson());

class CreateDeviceConsentResponse {
  String id;
  String personId;
  DeviceConsentEventType eventType;
  DateTime confirmedAt;
  DateTime createdAt;

  CreateDeviceConsentResponse({
    required this.id,
    required this.personId,
    required this.eventType,
    required this.confirmedAt,
    required this.createdAt,
  });

  factory CreateDeviceConsentResponse.fromJson(Map<String, dynamic> json) =>
      CreateDeviceConsentResponse(
        id: json["id"],
        personId: json["person_id"],
        eventType: getEventType(json["event_type"]),
        confirmedAt: DateTime.parse(json["confirmed_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "person_id": personId,
        "event_type": eventType.name,
        "confirmed_at": confirmedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
