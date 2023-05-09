import 'package:solarisdemo/models/change_request.dart';
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  group('ChangeRequestConfirm', () {
    final changeRequestConfirmJson = {
      'tan': 'test_tan',
    };

    final changeRequestConfirm = ChangeRequestConfirm(tan: 'test_tan');

    test('fromJson creates a ChangeRequestConfirm object from JSON', () {
      final changeRequestConfirmFromJson =
          ChangeRequestConfirm.fromJson(changeRequestConfirmJson);
      expect(changeRequestConfirmFromJson, isA<ChangeRequestConfirm>());
      expect(changeRequestConfirmFromJson.tan, changeRequestConfirm.tan);
    });

    test('toJson creates a JSON object from a ChangeRequestConfirm object', () {
      final changeRequestConfirmToJson = changeRequestConfirm.toJson();
      expect(changeRequestConfirmToJson, isA<Map<String, dynamic>>());
      expect(changeRequestConfirmToJson['tan'], changeRequestConfirm.tan);
    });

    test(
        'fromRawJson creates a ChangeRequestConfirm object from raw JSON string',
        () {
      final rawJson = json.encode(changeRequestConfirmJson);
      final changeRequestConfirmFromRawJson =
          ChangeRequestConfirm.fromRawJson(rawJson);
      expect(changeRequestConfirmFromRawJson, isA<ChangeRequestConfirm>());
      expect(changeRequestConfirmFromRawJson.tan, changeRequestConfirm.tan);
    });

    test(
        'toRawJson creates a raw JSON string from a ChangeRequestConfirm object',
        () {
      final rawJson = changeRequestConfirm.toRawJson();
      expect(rawJson, isA<String>());
      final decodedJson = json.decode(rawJson);
      expect(decodedJson['tan'], changeRequestConfirm.tan);
    });
  });

  group('ChangeRequestToken', () {
    final changeRequestTokenJson = {
      'token': 'test_token',
    };

    final changeRequestToken = ChangeRequestToken(token: 'test_token');

    test('fromJson creates a ChangeRequestToken object from JSON', () {
      final changeRequestTokenFromJson =
          ChangeRequestToken.fromJson(changeRequestTokenJson);
      expect(changeRequestTokenFromJson, isA<ChangeRequestToken>());
      expect(changeRequestTokenFromJson.token, changeRequestToken.token);
    });

    test('toJson creates a JSON object from a ChangeRequestToken object', () {
      final changeRequestTokenToJson = changeRequestToken.toJson();
      expect(changeRequestTokenToJson, isA<Map<String, dynamic>>());
      expect(changeRequestTokenToJson['token'], changeRequestToken.token);
    });

    test('fromRawJson creates a ChangeRequestToken object from raw JSON string',
        () {
      final rawJson = json.encode(changeRequestTokenJson);
      final changeRequestTokenFromRawJson = changeRequestTokenFromJson(rawJson);
      expect(changeRequestTokenFromRawJson, isA<ChangeRequestToken>());
      expect(changeRequestTokenFromRawJson.token, changeRequestToken.token);
    });

    test('toRawJson creates a raw JSON string from a ChangeRequestToken object',
        () {
      final rawJson = changeRequestTokenToJson(changeRequestToken);
      expect(rawJson, isA<String>());
      final decodedJson = json.decode(rawJson);
      expect(decodedJson['token'], changeRequestToken.token);
    });

    test('fromJson with empty strings', () {
      final emptyJson = {
        'tan': '',
        'token': '',
      };

      final changeRequestConfirmEmpty =
          ChangeRequestConfirm.fromJson(emptyJson);
      final changeRequestTokenEmpty = ChangeRequestToken.fromJson(emptyJson);

      expect(changeRequestConfirmEmpty.tan, '');
      expect(changeRequestTokenEmpty.token, '');
    });
    test('fromJson with null values should throw TypeError', () {
      final nullJson = {
        'tan': null,
        'token': null,
      };

      expect(() => ChangeRequestConfirm.fromJson(nullJson),
          throwsA(isA<TypeError>()));
      expect(() => ChangeRequestToken.fromJson(nullJson),
          throwsA(isA<TypeError>()));
    });

    test('fromJson with unexpected JSON keys should ignore the extra keys', () {
      final extraKeysJson = {
        'tan': 'test_tan',
        'token': 'test_token',
        'extra_key': 'extra_value',
      };

      final changeRequestConfirmExtra =
          ChangeRequestConfirm.fromJson(extraKeysJson);
      final changeRequestTokenExtra =
          ChangeRequestToken.fromJson(extraKeysJson);

      expect(changeRequestConfirmExtra.tan, 'test_tan');
      expect(changeRequestTokenExtra.token, 'test_token');
    });

    test('fromJson with missing JSON keys should throw Error', () {
      final Map<String, dynamic> missingKeysJson = {};

      expect(() => ChangeRequestConfirm.fromJson(missingKeysJson),
          throwsA(isA<Error>()));
      expect(() => ChangeRequestToken.fromJson(missingKeysJson),
          throwsA(isA<Error>()));
    });
  });

  group('ChangeRequestConfirmed', () {
    test('fromJson with empty strings and null values', () {
      final Map<String, dynamic> emptyResponseBody = {
        'asd': 'asd',
      };
      final Map<String, dynamic> emptyResponse = {
        'status': '',
        'response_code': null,
        'id': '',
        'response_body': emptyResponseBody,
      };
      final Map<String, dynamic> emptyJson = {
        'success': true,
        'response': emptyResponse
      };

      final changeRequestConfirmedEmpty =
          ChangeRequestConfirmed.fromJson(emptyJson);
      expect(changeRequestConfirmedEmpty.success, true);
      expect(changeRequestConfirmedEmpty.response!.status, '');
      expect(changeRequestConfirmedEmpty.response!.responseCode, null);
      expect(changeRequestConfirmedEmpty.response!.id, '');
    });

    test('fromJson with unexpected JSON keys should ignore the extra keys', () {
      final extraKeysJson = {
        'success': true,
        'response': {
          'status': 'test_status',
          'response_code': 123,
          'id': 'test_id',
          'response_body': {
            'test_key': 'test_value',
          },
          'extra_key': 'extra_value',
        },
        'extra_key': 'extra_value',
      };

      final changeRequestConfirmedExtra =
          ChangeRequestConfirmed.fromJson(extraKeysJson);
      expect(changeRequestConfirmedExtra.success, true);
      expect(changeRequestConfirmedExtra.response!.status, 'test_status');
      expect(changeRequestConfirmedExtra.response!.responseCode, 123);
      expect(changeRequestConfirmedExtra.response!.id, 'test_id');
    });

    test('fromJson creates a ChangeRequestConfirmed object with a response',
        () {
      final json = {
        'success': true,
        'response': {
          'status': 'test_status',
          'response_code': 123,
          'id': 'test_id',
          'response_body': {
            'test_key': 'test_value',
          },
        },
      };

      final changeRequestConfirmed = ChangeRequestConfirmed.fromJson(json);
      expect(changeRequestConfirmed.success, true);
      expect(changeRequestConfirmed.response!.status, 'test_status');
      expect(changeRequestConfirmed.response!.responseCode, 123);
      expect(changeRequestConfirmed.response!.id, 'test_id');
      expect(
          changeRequestConfirmed.response!.responseBody, isA<ResponseBody>());
    });

    test('toJson creates a JSON object from a ChangeRequestConfirmed object',
        () {
      final json = {
        'success': true,
        'response': {
          'status': 'test_status',
          'response_code': 123,
          'id': 'test_id',
          'response_body': {
            'test_key': 'test_value',
          },
        },
      };

      final changeRequestConfirmed = ChangeRequestConfirmed.fromJson(json);
      final toJson = changeRequestConfirmed.toJson();

      expect(toJson['success'], true);
      expect(toJson['response']['status'], 'test_status');
      expect(toJson['response']['response_code'], 123);
      expect(toJson['response']['id'], 'test_id');
      expect(toJson['response']['response_body'], isA<Map<String, dynamic>>());
    });

    test('fromJson creates a ChangeRequestConfirmed object without a response',
        () {
      final json = {
        'success': false,
        'response': null,
      };

      final changeRequestConfirmed = ChangeRequestConfirmed.fromJson(json);
      expect(changeRequestConfirmed.success, false);
      expect(changeRequestConfirmed.response, null);
    });

    test(
        'toJson creates a JSON object from a ChangeRequestConfirmed object without a response',
        () {
      final json = {
        'success': false,
        'response': null,
      };

      final changeRequestConfirmed = ChangeRequestConfirmed.fromJson(json);
      final toJson = changeRequestConfirmed.toJson();

      expect(toJson['success'], false);
      expect(toJson['response'], null);
    });
  });

  group('Response', () {
    test('fromJson creates a Response object with a responseBody', () {
      final json = {
        'status': 'test_status',
        'response_code': 123,
        'id': 'test_id',
        'response_body': {
          'test_key': 'test_value',
        },
      };

      final response = Response.fromJson(json);
      expect(response.status, 'test_status');
      expect(response.responseCode, 123);
      expect(response.id, 'test_id');
      expect(response.responseBody, isA<ResponseBody>());
    });

    test(
        'toJson creates a JSON object from a Response object with a responseBody',
        () {
      final json = {
        'status': 'test_status',
        'response_code': 123,
        'id': 'test_id',
        'response_body': {
          'test_key': 'test_value',
        },
      };

      final response = Response.fromJson(json);
      final toJson = response.toJson();

      expect(toJson['status'], 'test_status');
      expect(toJson['response_code'], 123);
      expect(toJson['id'], 'test_id');
      expect(toJson['response_body'], isA<Map<String, dynamic>>());
    });

    test('fromJson creates a Response object without a responseBody', () {
      final json = {
        'status': 'test_status',
        'response_code': 123,
        'id': 'test_id',
        'response_body': null,
      };

      final response = Response.fromJson(json);
      expect(response.status, 'test_status');
      expect(response.responseCode, 123);
      expect(response.id, 'test_id');
      expect(response.responseBody, null);
    });

    test(
        'toJson creates a JSON object from a Response object without a responseBody',
        () {
      final json = {
        'status': 'test_status',
        'response_code': 123,
        'id': 'test_id',
        'response_body': null,
      };

      final response = Response.fromJson(json);
      final toJson = response.toJson();

      expect(toJson['status'], 'test_status');
      expect(toJson['response_code'], 123);
      expect(toJson['id'], 'test_id');
      expect(toJson['response_body'], null);
    });

    test('fromJson creates a Response object from JSON with a responseBody',
        () {
      final jsonResponse = {
        "status": "test_status",
        "response_code": 123,
        "id": "test_id",
        "response_body": {
          "test_key": "test_value",
        }
      };

      final response = Response.fromJson(jsonResponse);
      expect(response.status, 'test_status');
      expect(response.responseCode, 123);
      expect(response.id, 'test_id');
      expect(response.responseBody, isA<ResponseBody>());
    });

    test(
        'toJson creates a JSON object from a Response object with a responseBody of type Map<String, dynamic',
        () {
      final response = Response(
        status: 'test_status',
        responseCode: 123,
        id: 'test_id',
        responseBody: ResponseBody(),
      );

      final jsonResponse = response.toJson();
      expect(jsonResponse['status'], 'test_status');
      expect(jsonResponse['response_code'], 123);
      expect(jsonResponse['id'], 'test_id');
      expect(jsonResponse['response_body'], isA<Map<String, dynamic>>());
    });

    test(
        'fromJson creates a Response object from JSON without a responseBody with null value',
        () {
      final jsonResponse = {
        "status": "test_status",
        "response_code": 123,
        "id": "test_id",
        "response_body": null
      };

      final response = Response.fromJson(jsonResponse);
      expect(response.status, 'test_status');
      expect(response.responseCode, 123);
      expect(response.id, 'test_id');
      expect(response.responseBody, null);
    });

    test(
        'toJson creates a JSON object from a Response object without a responseBody',
        () {
      final response = Response(
        status: 'test_status',
        responseCode: 123,
        id: 'test_id',
        responseBody: null,
      );

      final jsonResponse = response.toJson();
      expect(jsonResponse['status'], 'test_status');
      expect(jsonResponse['response_code'], 123);
      expect(jsonResponse['id'], 'test_id');
      expect(jsonResponse['response_body'], null);
    });
  });

  group('ResponseBody', () {
    test('fromRawJson should return an instance of ResponseBody', () {
      const jsonString = '{}';
      final responseBody = ResponseBody.fromRawJson(jsonString);
      expect(responseBody, isA<ResponseBody>());
    });

    test('toRawJson should return a valid JSON string', () {
      const jsonString = '{}';
      final responseBody = ResponseBody.fromRawJson(jsonString);
      final rawJsonString = responseBody.toRawJson();
      expect(rawJsonString, equals(jsonString));
    });

    test('fromJson should return an instance of ResponseBody', () {
      final Map<String, dynamic> jsonMap = {};
      final responseBody = ResponseBody.fromJson(jsonMap);
      expect(responseBody, isA<ResponseBody>());
    });

    test('toJson should return an empty map', () {
      final responseBody = ResponseBody();
      final jsonMap = responseBody.toJson();
      expect(jsonMap, equals({}));
    });
  });
}
