import 'dart:developer';

import 'package:solarisdemo/models/authorization_request.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  group('AuthorizationRequest', () {
    final authRequestClassJson = {
      'id': 'test_id',
      'status': 'test_status',
      'updated_at': '2023-05-09T12:00:00.000Z',
    };

    final authRequestJson = {
      'authorizationRequest': authRequestClassJson,
      'confirmUrl': 'https://example.com/confirm',
    };

    final authRequestClass = AuthorizationRequestClass(
      id: 'test_id',
      status: 'test_status',
      updatedAt: DateTime.parse('2023-05-09T12:00:00.000Z'),
    );

    final authRequest = AuthorizationRequest(
      authorizationRequest: authRequestClass,
      confirmUrl: 'https://example.com/confirm',
    );

    test('fromJson() creates an AuthorizationRequest object from JSON', () {
      final authRequestFromJson =
          AuthorizationRequest.fromJson(authRequestJson);
      expect(authRequestFromJson, isA<AuthorizationRequest>());
      expect(authRequestFromJson.authorizationRequest.id,
          authRequest.authorizationRequest.id);
      expect(authRequestFromJson.authorizationRequest.status,
          authRequest.authorizationRequest.status);
      expect(authRequestFromJson.authorizationRequest.updatedAt,
          authRequest.authorizationRequest.updatedAt);
      expect(authRequestFromJson.confirmUrl, authRequest.confirmUrl);
    });

    test('toJson() creates a JSON object from an AuthorizationRequest object',
        () {
      final authRequestToJson = authRequest.toJson();
      expect(authRequestToJson, isA<Map<String, dynamic>>());
      expect(authRequestToJson['authorizationRequest'],
          isA<Map<String, dynamic>>());
      expect(authRequestToJson['authorizationRequest']['id'],
          authRequest.authorizationRequest.id);
      expect(authRequestToJson['authorizationRequest']['status'],
          authRequest.authorizationRequest.status);
      expect(authRequestToJson['authorizationRequest']['updated_at'],
          authRequest.authorizationRequest.updatedAt.toIso8601String());
      expect(authRequestToJson['confirmUrl'], authRequest.confirmUrl);
    });

    test(
        'fromRawJson() creates an AuthorizationRequest object from raw JSON string',
        () {
      final rawJson = json.encode(authRequestJson);
      final authRequestFromRawJson = AuthorizationRequest.fromRawJson(rawJson);
      expect(authRequestFromRawJson, isA<AuthorizationRequest>());
      expect(authRequestFromRawJson.authorizationRequest.id,
          authRequest.authorizationRequest.id);
      expect(authRequestFromRawJson.authorizationRequest.status,
          authRequest.authorizationRequest.status);
      expect(authRequestFromRawJson.authorizationRequest.updatedAt,
          authRequest.authorizationRequest.updatedAt);
      expect(authRequestFromRawJson.confirmUrl, authRequest.confirmUrl);
    });

    test(
        'toRawJson() creates a raw JSON string from an AuthorizationRequest object',
        () {
      final rawJson = authRequest.toRawJson();
      expect(rawJson, isA<String>());
      final decodedJson = json.decode(rawJson);
      expect(decodedJson['authorizationRequest'], isA<Map<String, dynamic>>());
      expect(decodedJson['authorizationRequest']['id'],
          authRequest.authorizationRequest.id);
      expect(decodedJson['authorizationRequest']['status'],
          authRequest.authorizationRequest.status);
      expect(decodedJson['authorizationRequest']['updated_at'],
          authRequest.authorizationRequest.updatedAt.toIso8601String());
      expect(decodedJson['confirmUrl'], authRequest.confirmUrl);
    });
  });
  group('AuthorizationRequestClass', () {
    log('AuthorizationRequestClass');
    final authRequestJson = {
      'id': 'test_id',
      'status': 'test_status',
      'updated_at': '2023-05-09T12:00:00.000Z',
    };

    final authRequest = AuthorizationRequestClass(
      id: 'test_id',
      status: 'test_status',
      updatedAt: DateTime.parse('2023-05-09T12:00:00.000Z'),
    );

    test('fromJson() creates an AuthorizationRequestClass object from JSON', () {
      final authRequestFromJson =
          AuthorizationRequestClass.fromJson(authRequestJson);
      expect(authRequestFromJson, isA<AuthorizationRequestClass>());
      expect(authRequestFromJson.id, authRequest.id);
      expect(authRequestFromJson.status, authRequest.status);
      expect(authRequestFromJson.updatedAt, authRequest.updatedAt);
    });

    test(
        'toJson() creates a JSON object from an AuthorizationRequestClass object',
        () {
      final authRequestToJson = authRequest.toJson();
      expect(authRequestToJson, isA<Map<String, dynamic>>());
      expect(authRequestToJson['id'], authRequest.id);
      expect(authRequestToJson['status'], authRequest.status);
      expect(authRequestToJson['updated_at'],
          authRequest.updatedAt.toIso8601String());
    });

    test(
        'fromRawJson() creates an AuthorizationRequestClass object from raw JSON string',
        () {
      final rawJson = json.encode(authRequestJson);
      final authRequestFromRawJson =
          AuthorizationRequestClass.fromRawJson(rawJson);
      expect(authRequestFromRawJson, isA<AuthorizationRequestClass>());
      expect(authRequestFromRawJson.id, authRequest.id);
      expect(authRequestFromRawJson.status, authRequest.status);
      expect(authRequestFromRawJson.updatedAt, authRequest.updatedAt);
    });

    test(
        'toRawJson() creates a raw JSON string from an AuthorizationRequestClass object',
        () {
      final rawJson = authRequest.toRawJson();
      expect(rawJson, isA<String>());
      final decodedJson = json.decode(rawJson);
      expect(decodedJson['id'], authRequest.id);
      expect(decodedJson['status'], authRequest.status);
      expect(
          decodedJson['updated_at'], authRequest.updatedAt.toIso8601String());
    });
  });
}
