import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_presenter.dart';
import 'package:solarisdemo/models/change_request/change_request_error_type.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

void main() {
  const referenceAccount = PersonReferenceAccount(name: "Name", iban: "iban");
  final personAccount = PersonAccount();
  const transferAuthorizationRequest = TransferAuthorizationRequest(
    id: "id",
    status: 'NEED_CONFIRMATION',
    confirmUrl: "url",
    stringToSign: null,
  );

  final personAccountState = PersonAccountFetchedState(personAccount);
  final referenceAccountState = ReferenceAccountFetchedState(referenceAccount);

  test("When person account and reference account are not set it should return failed view model", () {
    //given
    final referenceAccountState = ReferenceAccountInitialState();
    final personAccountState = PersonAccountInitialState();

    //when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: TransferInitialState(),
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, isA<TransferFailedViewModel>());
  });

  test("When transfer state is initial it should return initial view model", () {
    //given
    final transferState = TransferInitialState();

    //when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: transferState,
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, isA<TransferInitialViewModel>());
  });

  test("When transfer state is loading it should return loading view model", () {
    //given
    final transferState = TransferLoadingState();

    //when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: transferState,
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, isA<TransferLoadingViewModel>());
  });

  test("When transfer state is failed it should return failed view model", () {
    //given
    final transferState = TransferFailedState(ChangeRequestErrorType.unknown);

    //when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: transferState,
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    //then
    expect(viewModel, isA<TransferFailedViewModel>());
  });

  test("When transfer state is need confirmation state it should return confirmation view model", () {
    // given
    final transferState = TransferNeedConfirmationState(transferAuthorizationRequest: transferAuthorizationRequest);

    // when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: transferState,
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    // then
    expect(viewModel, isA<TransferConfirmationViewModel>());
  });

  test("When transfer state is confirmed it should return confirmed view model", () {
    // given
    final transferState = TransferConfirmedState(amount: 100);

    // when
    final viewModel = TransferPresenter.presentTransfer(
      transferState: transferState,
      referenceAccountState: referenceAccountState,
      personAccountState: personAccountState,
    );

    // then
    expect(viewModel, isA<TransferConfirmedViewModel>());
    expect((viewModel as TransferConfirmedViewModel).amount, 100);
  });
}
