import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_presenter.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

void main() {
  const referenceAccount = PersonReferenceAccount(name: "Name", iban: "iban");

  test("When fetching is in progress, it should return loading", () {
    //given
    final referenceAccountState = ReferenceAccountLoadingState();

    //when
    final viewModel = TransferPresenter.presentTransfer(referenceAccountState: referenceAccountState);

    //then
    expect(viewModel, TransferLoadingViewModel());
  });

  test("When fetching fails, it should return error", () {
    //given
    final referenceAccountState = ReferenceAccountErrorState();

    //when
    final viewModel = TransferPresenter.presentTransfer(referenceAccountState: referenceAccountState);

    //then
    expect(viewModel, TransferErrorViewModel());
  });

  test("When fetching is successful, it should return fetched accounts model", () {
    //given
    final referenceAccountState = ReferenceAccountFetchedState(referenceAccount);

    //when
    final viewModel = TransferPresenter.presentTransfer(referenceAccountState: referenceAccountState);

    //then
    expect(viewModel, TransferFetchedAccountsViewModel(referenceAccount: referenceAccount));
  });

  test("When state is initial, it should return initial model", () {
    //given
    final referenceAccountState = ReferenceAccountInitialState();

    //when
    final viewModel = TransferPresenter.presentTransfer(referenceAccountState: referenceAccountState);

    //then
    expect(viewModel, TransferInitialViewModel());
  });
}
