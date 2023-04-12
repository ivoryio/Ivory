// To parse this JSON data, do
//
//     final authorizationRequest = authorizationRequestFromJson(jsonString);

import 'dart:convert';

class AuthorizationRequest {
  AuthorizationRequest({
    required this.authorizationRequest,
    required this.confirmUrl,
  });

  final AuthorizationRequestClass authorizationRequest;
  final String confirmUrl;

  factory AuthorizationRequest.fromRawJson(String str) =>
      AuthorizationRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthorizationRequest.fromJson(Map<String, dynamic> json) =>
      AuthorizationRequest(
        authorizationRequest:
            AuthorizationRequestClass.fromJson(json["authorizationRequest"]),
        confirmUrl: json["confirmUrl"],
      );

  Map<String, dynamic> toJson() => {
        "authorizationRequest": authorizationRequest.toJson(),
        "confirmUrl": confirmUrl,
      };
}

class AuthorizationRequestClass {
  AuthorizationRequestClass({
    required this.id,
    required this.status,
    required this.updatedAt,
  });

  final String id;
  final String status;
  final DateTime updatedAt;

  factory AuthorizationRequestClass.fromRawJson(String str) =>
      AuthorizationRequestClass.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthorizationRequestClass.fromJson(Map<String, dynamic> json) =>
      AuthorizationRequestClass(
        id: json["id"],
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "updated_at": updatedAt.toIso8601String(),
      };
}
