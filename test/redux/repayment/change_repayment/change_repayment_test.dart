import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_state.dart';

import '../../../setup/create_store.dart';
import '../../../setup/create_app_state.dart';
import 'change_repayment_mocks.dart';

class MockUser extends Mock implements User {}

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

void main() {
  AuthenticatedUser user = AuthenticatedUser(
    cognito: MockUser(),
    person: MockPerson(),
    personAccount: MockPersonAccount(),
  );

  test('When asking to fetch card application the first time you enter the screen it should have a loading state',
      () async {
    //given
    final store = createTestStore(
      cardApplicationService: FakeCardApplicationService(),
      initialState: createAppState(
        cardApplicationState: CardApplicationInitialState(),
      ),
    );
    final appState = store.onChange.isEmpty;

    //when
    store.dispatch(GetCardApplicationCommandAction(user: user));

    //then
    expect(await appState, false);
  });

  test('When fetching minimum amount is failing should update with error', () async {
    //given
    final store = createTestStore(
      cardApplicationService: FakeFailingCardApplicationService(),
      initialState: createAppState(
        cardApplicationState: CardApplicationInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((element) => element.cardApplicationState is CardApplicationErrorState);

    //when
    store.dispatch(GetCardApplicationCommandAction(user: user));

    //then
    expect((await appState).cardApplicationState, isA<CardApplicationErrorState>());
  });

  test('When updating minimum amount is failing should update with error', () async {
    //given
    final store = createTestStore(
      cardApplicationService: FakeFailingCardApplicationService(),
      initialState: createAppState(
        cardApplicationState: CardApplicationInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere((element) => element.cardApplicationState is CardApplicationErrorState);

    //when
    store.dispatch(UpdateCardApplicationCommandAction(
      user: user,
      fixedRate: 1000,
      id: 'ff46c26e244f482a955ec0bb9a0170d4ccla',
    ));

    //then
    expect((await appState).cardApplicationState, isA<CardApplicationErrorState>());
  });

  test('When fetching minimum amount is successful should update with fetched data', () async {
    //given
    final store = createTestStore(
      cardApplicationService: FakeCardApplicationService(),
      initialState: createAppState(
        cardApplicationState: CardApplicationInitialState(),
      ),
    );
    final appState =
        store.onChange.firstWhere((element) => element.cardApplicationState is CardApplicationFetchedState);

    //when
    store.dispatch(GetCardApplicationCommandAction(user: user));

    //then
    expect((await appState).cardApplicationState, isA<CardApplicationFetchedState>());
  });
}
