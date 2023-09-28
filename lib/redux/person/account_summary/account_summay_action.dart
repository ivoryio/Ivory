import 'package:solarisdemo/models/person_account_summary.dart';

import '../../../models/user.dart';

class GetAccountSummaryCommandAction {
  final User user;

  GetAccountSummaryCommandAction({required this.user});
}

class AccountSummaryLoadingEventAction {}

class AccountSummaryFailedEventAction {}

class AccountSummaryFetchedEventAction {
  final PersonAccountSummary accountSummary;

  AccountSummaryFetchedEventAction({required this.accountSummary});
}
