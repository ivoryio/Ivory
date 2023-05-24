import 'dart:convert';

CreateDevice createDeviceFromJson(String str) =>
    CreateDevice.fromJson(json.decode(str));

String createDeviceToJson(CreateDevice data) => json.encode(data.toJson());

class CreateDevice {
  String number;
  String deviceData;

  CreateDevice({
    required this.number,
    required this.deviceData,
  });

  factory CreateDevice.fromJson(Map<String, dynamic> json) => CreateDevice(
        number: json["number"],
        deviceData: json["device_data"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "device_data": deviceData,
      };
}
