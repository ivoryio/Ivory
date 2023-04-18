import 'dart:convert';

class ChangeRequestConfirm {
  ChangeRequestConfirm({
    required this.tan,
  });

  final String tan;

  factory ChangeRequestConfirm.fromRawJson(String str) =>
      ChangeRequestConfirm.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangeRequestConfirm.fromJson(Map<String, dynamic> json) =>
      ChangeRequestConfirm(
        tan: json["tan"],
      );

  Map<String, dynamic> toJson() => {
        "tan": tan,
      };
}

ChangeRequestToken changeRequestTokenFromJson(String str) =>
    ChangeRequestToken.fromJson(json.decode(str));

String changeRequestTokenToJson(ChangeRequestToken data) =>
    json.encode(data.toJson());

class ChangeRequestToken {
  ChangeRequestToken({
    required this.token,
  });

  String token;

  factory ChangeRequestToken.fromJson(Map<String, dynamic> json) =>
      ChangeRequestToken(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}

class ChangeRequestConfirmed {
  ChangeRequestConfirmed({
    this.success,
    this.response,
  });

  final bool? success;
  final Response? response;

  factory ChangeRequestConfirmed.fromRawJson(String str) =>
      ChangeRequestConfirmed.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChangeRequestConfirmed.fromJson(Map<String, dynamic> json) =>
      ChangeRequestConfirmed(
        success: json["success"],
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "response": response?.toJson(),
      };
}

class Response {
  Response({
    this.status,
    this.responseCode,
    this.id,
    this.responseBody,
  });

  final String? status;
  final int? responseCode;
  final String? id;
  final ResponseBody? responseBody;

  factory Response.fromRawJson(String str) =>
      Response.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        responseCode: json["response_code"],
        id: json["id"],
        responseBody: json["response_body"] == null
            ? null
            : ResponseBody.fromJson(json["response_body"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "response_code": responseCode,
        "id": id,
        "response_body": responseBody?.toJson(),
      };
}

class ResponseBody {
  ResponseBody();

  factory ResponseBody.fromRawJson(String str) =>
      ResponseBody.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResponseBody.fromJson(Map<String, dynamic> json) => ResponseBody();

  Map<String, dynamic> toJson() => {};
}
