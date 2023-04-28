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
  String confirmedAt;

  CreateDeviceConsentRequest({
    required this.eventType,
    required this.confirmedAt,
  });

  factory CreateDeviceConsentRequest.fromJson(Map<String, dynamic> json) =>
      CreateDeviceConsentRequest(
        eventType: getEventType(json["event_type"]),
        confirmedAt: json["confirmed_at"],
      );

  Map<String, dynamic> toJson() => {
        "event_type": eventType.name,
        "confirmed_at": confirmedAt,
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
