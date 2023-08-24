import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_accounts_presenter.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

void main() {
  const referenceAccount = PersonReferenceAccount(name: "Name", iban: "iban");
  final personAccount = PersonAccount();

  test("When fetching is in progress for person account it should return loading", () {
    //given
    final referenceAccountState = ReferenceAccountInitialState();
    final personAccountState = PersonAccountLoadingState();

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, TransferAccountsLoadingViewModel());
  });

  test("When fetching is in progress for reference account it should return loading", () {
    //given
    final referenceAccountState = ReferenceAccountLoadingState();
    final personAccountState = PersonAccountInitialState();

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, TransferAccountsLoadingViewModel());
  });

  test("When fetching failed for person account it should return error", () {
    //given
    final referenceAccountState = ReferenceAccountInitialState();
    final personAccountState = PersonAccountErrorState();

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, TransferAccountsErrorViewModel());
  });

  test("When fetching failed for reference account it should return error", () {
    //given
    final referenceAccountState = ReferenceAccountErrorState();
    final personAccountState = PersonAccountInitialState();

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, TransferAccountsErrorViewModel());
  });

  test("When fetching succeeded for person account and reference account it should return fetched accounts", () {
    //given
    final referenceAccountState = ReferenceAccountFetchedState(referenceAccount);
    final personAccountState = PersonAccountFetchedState(personAccount);

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(
      viewModel,
      TransferAccountsFetchedViewModel(personAccount: personAccount, referenceAccount: referenceAccount),
    );
  });

  test("When is initial state it should return initial", () {
    //given
    final referenceAccountState = ReferenceAccountInitialState();
    final personAccountState = PersonAccountInitialState();

    //when
    final viewModel = TransferAccountsPresenter.presentTransfer(
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, TransferAccountsInitialViewModel());
  });
}
