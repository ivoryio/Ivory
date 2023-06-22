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
