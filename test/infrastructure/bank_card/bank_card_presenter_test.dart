import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';

class MockUser extends Mock implements User {}

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

void main() {
  final bankCard1 = BankCard(
    id: "inactive-card-id",
    accountId: "62a8f478184ae7cba59c633373c53286cacc",
    status: BankCardStatus.INACTIVE,
    type: BankCardType.VIRTUAL_VISA_CREDIT,
    representation: BankCardRepresentation(
      line1: "INACTIVE JOE",
      line2: "INACTIVE JOE",
      maskedPan: '493441******9641',
      formattedExpirationDate: '06/26',
    ),
  );

  final user = AuthenticatedUser(
    person: MockPerson(),
    cognito: MockUser(),
    personAccount: MockPersonAccount(),
  );

  //mock AuthenticatedUser

  test("when fetching is in progress should return loading", () {
    //given
    final bankCardState = BankCardLoadingState();
    //when
    final viewModel = BankCardPresenter.presentBankCard(
      bankCardState: bankCardState,
      user: user,
    );
    //then
    expect(viewModel, BankCardLoadingViewModel());
  });

  test("when fetching is failed should return error", () {
    //given
    final bankCardState = BankCardErrorState();
    //when
    final viewModel = BankCardPresenter.presentBankCard(bankCardState: bankCardState, user: user);
    //then
    expect(viewModel, BankCardErrorViewModel());
  });

  test("When fetching is successful should return a card", () {
    //given
    final bankCardState = BankCardFetchedState(bankCard1, user);

    //when
    final viewModel = BankCardPresenter.presentBankCard(bankCardState: bankCardState, user: user);

    //then
    expect(viewModel, BankCardFetchedViewModel(bankCard: bankCard1, user: user));
  });
}
