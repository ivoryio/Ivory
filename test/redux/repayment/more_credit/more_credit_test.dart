import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_action.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';

import '../../../setup/authentication_helper.dart';
import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import 'more_credit_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

  test(
      'When asking to fetch more credit the first time you enter the screen it should have a loading state',
      () async {
    //given
    final store = createTestStore(
        moreCreditService: FakeMoreCreditService(),
        initialState:
            createAppState(
              moreCreditState: MoreCreditInitialState(),
              authState: authState,
            ));

    final appState = store.onChange.isEmpty;

    //when
    store.dispatch(GetMoreCreditCommandAction());
    //then
    expect(await appState, false);
  });

  test('When fetching isWaitlisted is failing should update with error',
      () async {
    //given
    final store = createTestStore(
        moreCreditService: FakeFailingMoreCreditService(),
        initialState:
            createAppState(
              moreCreditState: MoreCreditInitialState(),
              authState: authState,
            ));

    final appState = store.onChange.firstWhere(
        (element) => element.moreCreditState is MoreCreditErrorState);

    //when
    store.dispatch(GetMoreCreditCommandAction());
    //then
    expect((await appState).moreCreditState, isA<MoreCreditErrorState>());
  });

  test(
      'When asking to fetch isWaitlisted the first time you enter the screen it should have a loading state',
      () async {
    //given
    final store = createTestStore(
        moreCreditService: FakeMoreCreditService(),
        initialState:
            createAppState(
              moreCreditState: MoreCreditInitialState(),
              authState: authState,
            ));

    final appState = store.onChange.isEmpty;

    //when
    store.dispatch(GetMoreCreditCommandAction());
    //then
    expect(await appState, false);
  });

  test(
      'When fetching isWaitlisted successfully should update with isWaitlisted',
      () async {
    //given
    final store = createTestStore(
        moreCreditService: FakeMoreCreditService(),
        initialState:
            createAppState(
              moreCreditState: MoreCreditInitialState(),
              authState: authState,
            ));

    final appState = store.onChange.firstWhere(
        (element) => element.moreCreditState is MoreCreditFetchedState);

    //when
    store.dispatch(GetMoreCreditCommandAction());
    //then
    final MoreCreditFetchedState moreCreditState =
        (await appState).moreCreditState as MoreCreditFetchedState;
    expect(moreCreditState.waitlist, false);
  });
}
