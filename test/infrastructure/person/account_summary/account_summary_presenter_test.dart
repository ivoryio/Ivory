import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/person/account_summary/account_summary_presenter.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';

void main() {
  final accountSummary = PersonAccountSummary(
    id: "id-123445",
    income: 123.45,
    spending: 678.9,
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
  );

  test("When fetching is in progress should return loading", () {
    //given
    final accountSummaryState = AccountSummaryLoadingState();
    //when
    final viewModel = AccountSummaryPresenter.presentAccountSummary(accountSummaryState: accountSummaryState);
    //then
    expect(viewModel, AccountSummaryLoadingViewModel());
  });

  test("When fetching is successfully should return account summary data", () {
    //given
    final accountSummaryState = WithAccountSummaryState(accountSummary);
    //when
    final viewModel = AccountSummaryPresenter.presentAccountSummary(accountSummaryState: accountSummaryState);
    //then
    expect(viewModel, AccountSummaryFetchedViewModel(accountSummary: accountSummary));
  });

  test("When fetching fails should return error", () {
    //given
    final accountSummaryState = AccountSummaryErrorState();
    //when
    final viewModel = AccountSummaryPresenter.presentAccountSummary(accountSummaryState: accountSummaryState);
    //then
    expect(viewModel, AccountSummaryErrorViewModel());
  });
}