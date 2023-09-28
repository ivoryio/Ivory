import 'package:equatable/equatable.dart';

import '../../../models/person_account_summary.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';

class AccountSummaryService extends ApiService {
  AccountSummaryService({
    super.user,
  });

  Future<AccountSummaryServiceResponse> getPersonAccountSummary({User? user}) async {
    if (user != null) {
      this.user = user;
    }
    try {
      String path = 'account/summary';

      var data = await get(path);
      final accountSummary = PersonAccountSummary.fromJson(data);
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