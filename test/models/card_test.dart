import 'package:solarisdemo/models/bank_card.dart';
import 'package:test/test.dart';

void main() {
  group('BankCard', () {
    test('fromJson/toJson', () {
      final Map<String, dynamic> jsonData = {
        "id": "card_123",
        "account_id": "account_123",
        "status": BankCardStatus.ACTIVE.name,
        "type": BankCardType.VISA_BUSINESS_DEBIT.name,
        "representation": {
          "line_1": "John Doe",
          "masked_pan": "**** **** **** 1234",
          "formatted_expiration_date": "12/25"
        }
      };

      // Test fromJson
      final card = BankCard.fromJson(jsonData);
      expect(card.id, "card_123");
      expect(card.accountId, "account_123");
      expect(card.status, BankCardStatus.ACTIVE);
      expect(card.type, BankCardType.VISA_BUSINESS_DEBIT);
      expect(card.representation?.line1, "John Doe");
      expect(card.representation?.maskedPan, "**** **** **** 1234");
      expect(card.representation?.formattedExpirationDate, "12/25");

      // Test toJson
      final toJsonResult = card.toJson();
      expect(toJsonResult, jsonData);
    });

    test('fromRawJson/toRawJson', () {
      const String rawJsonData =
          '{"id":"card_123","account_id":"account_123","status":"ACTIVE","type":"VISA_BUSINESS_DEBIT","representation":{"line_1":"John Doe","masked_pan":"**** **** **** 1234","formatted_expiration_date":"12/25"}}';

      // Test fromRawJson
      final card = BankCard.fromRawJson(rawJsonData);
      expect(card.id, "card_123");
      expect(card.accountId, "account_123");
      expect(card.status, BankCardStatus.ACTIVE);
      expect(card.type, BankCardType.VISA_BUSINESS_DEBIT);
      expect(card.representation?.line1, "John Doe");
      expect(card.representation?.maskedPan, "**** **** **** 1234");
      expect(card.representation?.formattedExpirationDate, "12/25");

      // Test toRawJson
      final toRawJsonResult = card.toRawJson();
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

      final card = BankCard.fromJson(jsonData);
      expect(card.id, "card_123");
      expect(card.accountId, "account_123");
      expect(card.status, BankCardStatus.INACTIVE);
      expect(card.type, BankCardType.VIRTUAL_VISA_BUSINESS_DEBIT);
      expect(card.representation?.line1, "John Doe");
      expect(card.representation?.maskedPan, null);
      expect(card.representation?.formattedExpirationDate, "12/25");
    });

    test('fromJson with null representation', () {
      final Map<String, dynamic> jsonData = {
        "id": "card_123",
        "account_id": "account_123",
        "status": BankCardStatus.ACTIVE.name,
        "type": BankCardType.VISA_BUSINESS_DEBIT.name,
        "representation": null
      };

      final card = BankCard.fromJson(jsonData);
      expect(card.id, "card_123");
      expect(card.accountId, "account_123");
      expect(card.status, BankCardStatus.ACTIVE);
      expect(card.type, BankCardType.VISA_BUSINESS_DEBIT);
      expect(card.representation, isNull);
    });
  });

  group('BankCardRepresentation', () {
    test('fromRawJson/toRawJson', () {
      const String rawJsonData =
          '{"line_1":"John Doe","masked_pan":"**** **** **** 1234","formatted_expiration_date":"12/25"}';

      // Test fromRawJson
      final representation = BankCardRepresentation.fromRawJson(rawJsonData);
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

      final representation = BankCardRepresentation.fromJson(jsonData);
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

      final representation = BankCardRepresentation.fromJson(jsonData);
      expect(representation.line1, "");
      expect(representation.maskedPan, "");
      expect(representation.formattedExpirationDate, "");
    });
  });
}
