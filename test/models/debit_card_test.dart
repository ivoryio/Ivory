import 'package:solarisdemo/models/debit_card.dart';
import 'package:test/test.dart';

void main() {
  group('DebitCard', () {
    test('fromJson/toJson', () {
      final Map<String, dynamic> jsonData = {
        "id": "card_123",
        "account_id": "account_123",
        "status": DebitCardStatus.ACTIVE.name,
        "type": DebitCardType.VISA_BUSINESS_DEBIT.name,
        "representation": {
          "line_1": "John Doe",
          "masked_pan": "**** **** **** 1234",
          "formatted_expiration_date": "12/25"
        }
      };

      // Test fromJson
      final debitCard = DebitCard.fromJson(jsonData);
      expect(debitCard.id, "card_123");
      expect(debitCard.accountId, "account_123");
      expect(debitCard.status, DebitCardStatus.ACTIVE);
      expect(debitCard.type, DebitCardType.VISA_BUSINESS_DEBIT);
      expect(debitCard.representation?.line1, "John Doe");
      expect(debitCard.representation?.maskedPan, "**** **** **** 1234");
      expect(debitCard.representation?.formattedExpirationDate, "12/25");

      // Test toJson
      final toJsonResult = debitCard.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromRawJson/toRawJson', () {
      const String rawJsonData =
          '{"id":"card_123","account_id":"account_123","status":"ACTIVE","type":"VISA_BUSINESS_DEBIT","representation":{"line_1":"John Doe","masked_pan":"**** **** **** 1234","formatted_expiration_date":"12/25"}}';

      // Test fromRawJson
      final debitCard = DebitCard.fromRawJson(rawJsonData);
      expect(debitCard.id, "card_123");
      expect(debitCard.accountId, "account_123");
      expect(debitCard.status, DebitCardStatus.ACTIVE);
      expect(debitCard.type, DebitCardType.VISA_BUSINESS_DEBIT);
      expect(debitCard.representation?.line1, "John Doe");
      expect(debitCard.representation?.maskedPan, "**** **** **** 1234");
      expect(debitCard.representation?.formattedExpirationDate, "12/25");

      // Test toRawJson
      final toRawJsonResult = debitCard.toRawJson();
      expect(toRawJsonResult, rawJsonData);
    });

    test('fromJson with missing fields', () {
      final Map<String, dynamic> jsonData = {
        "id": "card_123",
        "account_id": "account_123",
        "representation": {
          "line_1": "John Doe",
          "formatted_expiration_date": "12/25"
        }
      };

      final debitCard = DebitCard.fromJson(jsonData);
      expect(debitCard.id, "card_123");
      expect(debitCard.accountId, "account_123");
      expect(debitCard.status, DebitCardStatus.INACTIVE);
      expect(debitCard.type, DebitCardType.VIRTUAL_VISA_BUSINESS_DEBIT);
      expect(debitCard.representation?.line1, "John Doe");
      expect(debitCard.representation?.maskedPan, null);
      expect(debitCard.representation?.formattedExpirationDate, "12/25");
    });

    test('fromJson with null representation', () {
      final Map<String, dynamic> jsonData = {
        "id": "card_123",
        "account_id": "account_123",
        "status": DebitCardStatus.ACTIVE.name,
        "type": DebitCardType.VISA_BUSINESS_DEBIT.name,
        "representation": null
      };

      final debitCard = DebitCard.fromJson(jsonData);
      expect(debitCard.id, "card_123");
      expect(debitCard.accountId, "account_123");
      expect(debitCard.status, DebitCardStatus.ACTIVE);
      expect(debitCard.type, DebitCardType.VISA_BUSINESS_DEBIT);
      expect(debitCard.representation, isNull);
    });
  });

  group('DebitCardRepresentation', () {
    test('fromRawJson/toRawJson', () {
      const String rawJsonData =
          '{"line_1":"John Doe","masked_pan":"**** **** **** 1234","formatted_expiration_date":"12/25"}';

      // Test fromRawJson
      final representation = DebitCardRepresentation.fromRawJson(rawJsonData);
      expect(representation.line1, "John Doe");
      expect(representation.maskedPan, "**** **** **** 1234");
      expect(representation.formattedExpirationDate, "12/25");

      // Test toRawJson
      final toRawJsonResult = representation.toRawJson();
      expect(toRawJsonResult, rawJsonData);
    });
    test('fromJson with missing fields', () {
      final Map<String, dynamic> jsonData = {
        "line_1": "John Doe",
        "masked_pan": "**** **** **** 1234"
      };

      final representation = DebitCardRepresentation.fromJson(jsonData);
      expect(representation.line1, "John Doe");
      expect(representation.maskedPan, "**** **** **** 1234");
      expect(representation.formattedExpirationDate, isNull);
    });

    test('fromJson with empty fields', () {
      final Map<String, dynamic> jsonData = {
        "line_1": "",
        "masked_pan": "",
        "formatted_expiration_date": ""
      };

      final representation = DebitCardRepresentation.fromJson(jsonData);
      expect(representation.line1, "");
      expect(representation.maskedPan, "");
      expect(representation.formattedExpirationDate, "");
    });
  });
}
