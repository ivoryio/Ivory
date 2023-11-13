import 'dart:convert';

String createDeviceToJson(CreateVerifyMobileNumberRequestBody data) => json.encode(data.toJson());

class CreateVerifyMobileNumberRequestBody {
  String number;
  String deviceData;

  CreateVerifyMobileNumberRequestBody({
    required this.number,
    this.deviceData = '',
  });

  Map<String, dynamic> toJson() => {
        "number": number,
        "device_data": deviceData,
      };
}

String confirmDeviceToJson(ConfirmMobileNumberRequestBody data) => json.encode(data.toJson());

class ConfirmMobileNumberRequestBody {
  String token;
  String number;
  String deviceData;

  ConfirmMobileNumberRequestBody({
    required this.token,
    required this.number,
    this.deviceData = '',
  });

  Map<String, dynamic> toJson() => {
        "token": token,
        "number": number,
        "device_data": deviceData,
      };
}
