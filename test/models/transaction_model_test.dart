import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:test/test.dart';

void main() {
  group('Transaction', () {
    test('fromJson and toJson should work correctly with all fields', () {
      var transaction = Transaction(
        id: '1',
        bookingType: 'type1',
        amount: Amount(value: 100.0, unit: 'Dollars', currency: 'USD'),
        description: 'desc1',
        endToEndId: 'end1',
        recipientBic: 'bic1',
        recipientIban: 'iban1',
        recipientName: 'name1',
        reference: 'ref1',
        bookingDate: '2022-01-01',
        valutaDate: '2022-01-01',
        metaInfo: 'meta1',
        recordedAt: DateTime.now(),
      );

      var json = transaction.toJson();
      var fromJson = Transaction.fromJson(json);

      expect(fromJson.id, equals(transaction.id));
      expect(fromJson.bookingType, equals(transaction.bookingType));
      expect(fromJson.amount!.value, equals(transaction.amount!.value));
      expect(fromJson.amount!.unit, equals(transaction.amount!.unit));
      expect(fromJson.amount!.currency, equals(transaction.amount!.currency));
      expect(fromJson.description, equals(transaction.description));
      expect(fromJson.endToEndId, equals(transaction.endToEndId));
      expect(fromJson.recipientBic, equals(transaction.recipientBic));
      expect(fromJson.recipientIban, equals(transaction.recipientIban));
      expect(fromJson.recipientName, equals(transaction.recipientName));
      expect(fromJson.reference, equals(transaction.reference));
      expect(fromJson.bookingDate, equals(transaction.bookingDate));
      expect(fromJson.valutaDate, equals(transaction.valutaDate));
      expect(fromJson.metaInfo, equals(transaction.metaInfo));
      expect(fromJson.recordedAt, equals(transaction.recordedAt));
    });

    test('fromJson and toJson should work correctly with null fields', () {
      var transaction = Transaction(
        recordedAt: DateTime.now(),
      );

      var json = transaction.toJson();
      var fromJson = Transaction.fromJson(json);

      expect(fromJson.id, isNull);
      expect(fromJson.bookingType, isNull);
      expect(fromJson.amount, isNull);
      expect(fromJson.description, isNull);
      expect(fromJson.endToEndId, "ID");
      expect(fromJson.recipientBic, isNull);
      expect(fromJson.recipientIban, isNull);
      expect(fromJson.recipientName, "SOLARIS");
      expect(fromJson.reference, isNull);
      expect(fromJson.bookingDate, isNull);
      expect(fromJson.valutaDate, isNull);
      expect(fromJson.metaInfo, isNull);
      expect(fromJson.recordedAt, equals(transaction.recordedAt));
    });
  });
}
