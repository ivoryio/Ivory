import 'package:solarisdemo/models/person_account_summary.dart';

import '../../../models/user.dart';

class GetAccountSummaryCommandAction {
  final User user;
  final bool forceAccountSummaryReload;

  GetAccountSummaryCommandAction({
    required this.user,
    required this.forceAccountSummaryReload,
  });
}

class AccountSummaryLoadingEventAction {}

class AccountSummaryFailedEventAction {}

class AccountSummaryFetchedEventAction {
  final PersonAccountSummary accountSummary;

  AccountSummaryFetchedEventAction({required this.accountSummary});
}
