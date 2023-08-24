import 'package:solarisdemo/models/transfer.dart';
import 'package:test/test.dart';

void main() {
  group('Transfer', () {
    test('fromJson and toJson should work correctly with all fields', () {
      var transfer = Transfer(
        type: TransferType.SEPA_CREDIT_TRANSFER,
        reference: 'ref1',
        description: 'desc1',
        recipientBic: 'bic1',
        endToEndId: 'end1',
        recipientName: 'name1',
        recipientIban: 'iban1',
        amount: AmountTransfer(value: 100.0, currency: 'USD'),
      );

      var json = transfer.toJson();
      var fromJson = Transfer.fromJson(json);

      expect(fromJson.type, equals(transfer.type));
      expect(fromJson.reference, equals(transfer.reference));
      expect(fromJson.description, equals(transfer.description));
      expect(fromJson.recipientBic, equals(transfer.recipientBic));
      expect(fromJson.endToEndId, equals(transfer.endToEndId));
      expect(fromJson.recipientName, equals(transfer.recipientName));
      expect(fromJson.recipientIban, equals(transfer.recipientIban));
      expect(fromJson.amount.value, equals(transfer.amount.value));
      expect(fromJson.amount.currency, equals(transfer.amount.currency));
    });

    test('fromJson should handle unknown transfer types', () {
      var json = {
        "type": "UNKNOWN_TYPE",
        "reference": "ref1",
        "description": "desc1",
        "recipient_bic": "bic1",
        "end_to_end_id": "end1",
        "recipient_name": "name1",
        "recipient_iban": "iban1",
        "amount": {"value": 100.0, "currency": "USD"},
      };

      var fromJson = Transfer.fromJson(json);

      expect(fromJson.type, equals(TransferType.UNKNOWN));
    });

    test('fromJson should throw TypeError on null values', () {
      var json = {
        "type": null,
        "reference": null,
        "description": null,
        "recipient_bic": null,
        "end_to_end_id": null,
        "recipient_name": null,
        "recipient_iban": null,
        "amount": null,
      };

      expect(() => Transfer.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson should should throw TypeError on empty json', () {
      const Map<String, dynamic> json = {};

      expect(() => Transfer.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson should should throw TypeError on incorrect value types', () {
      var json = {
        "type": 123,
        "reference": 123,
        "description": 123,
        "recipient_bic": 123,
        "end_to_end_id": 123,
        "recipient_name": 123,
        "recipient_iban": 123,
        "amount": "not an amount object",
      };

      expect(() => Transfer.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
