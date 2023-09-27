import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';

class AccountSummaryPresenter {
  static AccountSummaryViewModel presentAccountSummary({required AccountSummaryState accountSummaryState}) {
    if(accountSummaryState is AccountSummaryLoadingState) {
      return AccountSummaryLoadingViewModel();
    } else if(accountSummaryState is AccountSummaryErrorState) {
      return AccountSummaryErrorViewModel();
    } else if(accountSummaryState is WithAccountSummaryState) {
      return AccountSummaryFetchedViewModel(accountSummary: accountSummaryState.accountSummary);
    }
    return AccountSummaryInitialViewModel();
  }
}

abstract class AccountSummaryViewModel extends Equatable {
  final PersonAccountSummary? accountSummary;

  const AccountSummaryViewModel({this.accountSummary});

  @override
  List<Object?> get props => [accountSummary];
}

class AccountSummaryInitialViewModel extends AccountSummaryViewModel {}

class AccountSummaryLoadingViewModel extends AccountSummaryViewModel {}

class AccountSummaryErrorViewModel extends AccountSummaryViewModel {}

class AccountSummaryFetchedViewModel extends AccountSummaryViewModel {
  const AccountSummaryFetchedViewModel({
    required PersonAccountSummary accountSummary
  }) : super (accountSummary: accountSummary);
}