import 'package:solarisdemo/models/person_account_summary.dart';

class GetAccountSummaryCommandAction {
  final bool forceAccountSummaryReload;

  GetAccountSummaryCommandAction({
    required this.forceAccountSummaryReload,
  });
}

class AccountSummaryLoadingEventAction {}

class AccountSummaryFailedEventAction {}

class AccountSummaryFetchedEventAction {
  final PersonAccountSummary accountSummary;

  AccountSummaryFetchedEventAction({required this.accountSummary});
}
