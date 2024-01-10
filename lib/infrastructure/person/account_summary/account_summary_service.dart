import 'package:equatable/equatable.dart';
import 'package:solarisdemo/config.dart';

import '../../../models/person_account_summary.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class AccountSummaryService extends ApiService {
  AccountSummaryService({
    super.user,
  });

  Future<AccountSummaryServiceResponse> getPersonAccountSummary({required User user}) async {
    this.user = user;
    try {
      String path =
          ClientConfig.getFeatureFlags().simplifiedLogin ? 'account/v4/customer/${user.accountId}' : 'account/summary';

      // var data = await get(path);
      final data = {
        "available": 1000,
        "balance": 1000,
        "currency": "EUR",
        "customerId": 55667788990,
        "iban": {"iban": "FI7165429021331431"},
        "id": 1234567890,
        "name": "My example account name",
        "number": 123456789,
        "parentId": 9876543210,
        "paymentReference": {"number": 1234567897, "type": "MOD10"},
        "status": "ACCOUNT_BLOCKED",
        "template": "string"
      } as dynamic;

      final accountSummary = ClientConfig.getFeatureFlags().simplifiedLogin
          ? PersonAccountSummary(
              id: (data['id']).toString(),
              iban: data['iban']['iban'],
              availableBalance: Balance(
                currency: data['currency'],
                value: data['available'],
              ),
              balance: Balance(
                currency: data['currency'],
                value: data['balance'],
              ),
            )
          : PersonAccountSummary.fromJson(data);
      return GetAccountSummarySuccessResponse(accountSummary: accountSummary);
    } catch (e) {
      return AccountSummaryServiceErrorResponse();
    }
  }
}

abstract class AccountSummaryServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAccountSummarySuccessResponse extends AccountSummaryServiceResponse {
  final PersonAccountSummary accountSummary;

  GetAccountSummarySuccessResponse({required this.accountSummary});

  @override
  List<Object?> get props => [accountSummary];
}

class AccountSummaryServiceErrorResponse extends AccountSummaryServiceResponse {}
