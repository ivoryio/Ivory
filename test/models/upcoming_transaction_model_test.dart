import 'package:solarisdemo/models/transactions/upcoming_transaction_model.dart';
import 'package:test/test.dart';

void main() {
  group('UpcomingTransaction', () {
    test('fromJson and toJson should work correctly with all fields', () {
      var upcomingTransaction = UpcomingTransaction(
        id: '1',
        applicationId: '2',
        status: 'status1',
        statementDate: DateTime.now(),
        dueDate: DateTime.now(),
        outstandingAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        sddCollectionDate: DateTime.now(),
        previousBillAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        currentBillAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        totalOutstandingAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        minimumDueAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        outstandingSddrAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        repaymentType: 'type1',
        minimumAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        minimumPercentage: 100,
        gracePeriodInDays: 1,
        dunningFees:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        otherFees: CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        accumulatedInterestAmount:
            CardBillAmount(value: 100.0, unit: 'cents', currency: 'EUR'),
        postboxItemId: '1',
      );

      var json = upcomingTransaction.toJson();
      var fromJson = UpcomingTransaction.fromJson(json);

      expect(fromJson.id, equals(upcomingTransaction.id));
      expect(fromJson.applicationId, equals(upcomingTransaction.applicationId));
      expect(fromJson.status, equals(upcomingTransaction.status));
      expect(fromJson.statementDate, equals(upcomingTransaction.statementDate));
      expect(fromJson.dueDate, equals(upcomingTransaction.dueDate));
      expect(fromJson.outstandingAmount!.value,
          equals(upcomingTransaction.outstandingAmount!.value));
      expect(fromJson.outstandingAmount!.unit,
          equals(upcomingTransaction.outstandingAmount!.unit));
      expect(fromJson.outstandingAmount!.currency,
          equals(upcomingTransaction.outstandingAmount!.currency));
      expect(fromJson.startDate, equals(upcomingTransaction.startDate));
      expect(fromJson.endDate, equals(upcomingTransaction.endDate));
      expect(fromJson.sddCollectionDate,
          equals(upcomingTransaction.sddCollectionDate));
      expect(fromJson.previousBillAmount!.value,
          equals(upcomingTransaction.previousBillAmount!.value));
      expect(fromJson.previousBillAmount!.unit,
          equals(upcomingTransaction.previousBillAmount!.unit));
      expect(fromJson.previousBillAmount!.currency,
          equals(upcomingTransaction.previousBillAmount!.currency));
      expect(fromJson.currentBillAmount!.value,
          equals(upcomingTransaction.currentBillAmount!.value));
      expect(fromJson.currentBillAmount!.unit,
          equals(upcomingTransaction.currentBillAmount!.unit));
      expect(fromJson.currentBillAmount!.currency,
          equals(upcomingTransaction.currentBillAmount!.currency));
      expect(fromJson.totalOutstandingAmount!.value,
          equals(upcomingTransaction.totalOutstandingAmount!.value));
      expect(fromJson.totalOutstandingAmount!.unit,
          equals(upcomingTransaction.totalOutstandingAmount!.unit));
      expect(fromJson.totalOutstandingAmount!.currency,
          equals(upcomingTransaction.totalOutstandingAmount!.currency));
      expect(fromJson.minimumDueAmount!.value,
          equals(upcomingTransaction.minimumDueAmount!.value));
      expect(fromJson.minimumDueAmount!.unit,
          equals(upcomingTransaction.minimumDueAmount!.unit));
      expect(fromJson.minimumDueAmount!.currency,
          equals(upcomingTransaction.minimumDueAmount!.currency));
      expect(fromJson.outstandingSddrAmount!.value,
          equals(upcomingTransaction.outstandingSddrAmount!.value));
      expect(fromJson.outstandingSddrAmount!.unit,
          equals(upcomingTransaction.outstandingSddrAmount!.unit));
      expect(fromJson.outstandingSddrAmount!.currency,
          equals(upcomingTransaction.outstandingSddrAmount!.currency));
      expect(fromJson.repaymentType, equals(upcomingTransaction.repaymentType));
      expect(fromJson.minimumAmount!.value,
          equals(upcomingTransaction.minimumAmount!.value));
      expect(fromJson.minimumAmount!.unit,
          equals(upcomingTransaction.minimumAmount!.unit));
      expect(fromJson.minimumAmount!.currency,
          equals(upcomingTransaction.minimumAmount!.currency));
      expect(fromJson.minimumPercentage,
          equals(upcomingTransaction.minimumPercentage));
      expect(fromJson.gracePeriodInDays,
          equals(upcomingTransaction.gracePeriodInDays));
      expect(fromJson.dunningFees!.value,
          equals(upcomingTransaction.dunningFees!.value));
      expect(fromJson.dunningFees!.unit,
          equals(upcomingTransaction.dunningFees!.unit));
      expect(fromJson.dunningFees!.currency,
          equals(upcomingTransaction.dunningFees!.currency));
      expect(fromJson.otherFees!.value,
          equals(upcomingTransaction.otherFees!.value));
      expect(fromJson.otherFees!.unit,
          equals(upcomingTransaction.otherFees!.unit));
      expect(fromJson.otherFees!.currency,
          equals(upcomingTransaction.otherFees!.currency));
      expect(fromJson.accumulatedInterestAmount!.value,
          equals(upcomingTransaction.accumulatedInterestAmount!.value));
      expect(fromJson.accumulatedInterestAmount!.unit,
          equals(upcomingTransaction.accumulatedInterestAmount!.unit));
      expect(fromJson.accumulatedInterestAmount!.currency,
          equals(upcomingTransaction.accumulatedInterestAmount!.currency));
      expect(fromJson.postboxItemId, equals(upcomingTransaction.postboxItemId));
    });
  });
}
