import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_service.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/models/user.dart';

class FakeAccountSummaryService extends AccountSummaryService {
  @override
  Future<AccountSummaryServiceResponse> getPersonAccountSummary({User? user}) async {
    return GetAccountSummarySuccessResponse(
      accountSummary: PersonAccountSummary(
        id: "id-123445",
        iban: "DE60110101014274796688",
        bic: "SOBKDEB2XXX",
        balance: Balance(
          currency: "EUR",
          value: 1306.22,
          unit: "value",
        ),
        availableBalance: Balance(
          currency: "EUR",
          value: 1306.22,
          unit: "value",
        ),
        creditLimit: 10000,
        outstandingAmount: 200.32,
      ),
    );
  }
}

class FakeFailingAccountSummaryService extends AccountSummaryService {
  @override
  Future<AccountSummaryServiceResponse> getPersonAccountSummary({User? user}) async {
    return AccountSummaryServiceErrorResponse();
  }
}
