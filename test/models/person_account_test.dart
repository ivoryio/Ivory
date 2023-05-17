import 'package:solarisdemo/models/person_account.dart';
import 'package:test/test.dart';

void main() {
  group('PersonAccount', () {
    test('fromJson and toJson should work correctly with all fields', () {
      var personAccount = PersonAccount(
        id: '1',
        iban: 'iban1',
        bic: 'bic1',
        type: 'type1',
        overdraft: PersonAccountOverdraft(rate: 0.5, limit: 5000),
        balance: PersonAccountCurrencyValue(
            value: 1000.0, currency: 'USD', unit: 'Dollars'),
        income: PersonAccountCurrencyValue(
            value: 5000.0, currency: 'USD', unit: 'Dollars'),
        spending: PersonAccountCurrencyValue(
            value: 4000.0, currency: 'USD', unit: 'Dollars'),
        availableBalance: PersonAccountCurrencyValue(
            value: 6000.0, currency: 'USD', unit: 'Dollars'),
        lockingStatus: 'Locked',
        lockingReasons: ['reason1', 'reason2'],
        accountLimit: PersonAccountCurrencyValue(
            value: 10000.0, currency: 'USD', unit: 'Dollars'),
        personId: 'person1',
        businessId: 'business1',
        partnerId: 'partner1',
        openedAt: DateTime.parse('2022-01-01'),
        status: 'status1',
        closedAt: DateTime.parse('2023-01-01'),
      );

      var json = personAccount.toJson();
      var fromJson = PersonAccount.fromJson(json);

      expect(fromJson.id, equals(personAccount.id));
      expect(fromJson.iban, equals(personAccount.iban));
      expect(fromJson.bic, equals(personAccount.bic));
      expect(fromJson.type, equals(personAccount.type));
      expect(fromJson.overdraft!.rate, equals(personAccount.overdraft!.rate));
      expect(fromJson.overdraft!.limit, equals(personAccount.overdraft!.limit));
      expect(
          fromJson.balance!.currency, equals(personAccount.balance!.currency));
      expect(fromJson.balance!.value, equals(personAccount.balance!.value));
      expect(fromJson.balance!.unit, equals(personAccount.balance!.unit));
      expect(fromJson.income!.currency, equals(personAccount.income!.currency));
      expect(fromJson.income!.value, equals(personAccount.income!.value));
      expect(fromJson.income!.unit, equals(personAccount.income!.unit));
      expect(fromJson.spending!.currency,
          equals(personAccount.spending!.currency));
      expect(fromJson.spending!.value, equals(personAccount.spending!.value));
      expect(fromJson.spending!.unit, equals(personAccount.spending!.unit));
      expect(fromJson.availableBalance!.currency,
          equals(personAccount.availableBalance!.currency));
      expect(fromJson.availableBalance!.value,
          equals(personAccount.availableBalance!.value));
      expect(fromJson.availableBalance!.unit,
          equals(personAccount.availableBalance!.unit));
      expect(fromJson.lockingStatus, equals(personAccount.lockingStatus));
      expect(fromJson.lockingReasons, equals(personAccount.lockingReasons));
      expect(fromJson.accountLimit!.currency,
          equals(personAccount.accountLimit!.currency));
      expect(fromJson.accountLimit!.value,
          equals(personAccount.accountLimit!.value));
      expect(fromJson.accountLimit!.unit,
          equals(personAccount.accountLimit!.unit));
      expect(fromJson.personId, equals(personAccount.personId));
      expect(fromJson.businessId, equals(personAccount.businessId));
      expect(fromJson.partnerId, equals(personAccount.partnerId));
      expect(fromJson.openedAt, equals(personAccount.openedAt));
      expect(fromJson.status, equals(personAccount.status));
      expect(fromJson.closedAt, equals(personAccount.closedAt));
    });
  });
}
