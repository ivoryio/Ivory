import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_state.dart';

import '../../../setup/create_app_state.dart';
import '../../../setup/create_store.dart';
import '../../auth/auth_mocks.dart';
import 'account_summary_mocks.dart';

void main() {

  test("When asking to fetch account summary it should have a loading state", () async {
    //given
    final store = createTestStore(
        accountSummaryService: FakeAccountSummaryService(),
        initialState: createAppState(
          accountSummaryState: AccountSummaryInitialState(),
        )
    );

    final appState = store.onChange.firstWhere((element) => element.accountSummaryState is AccountSummaryLoadingState);
    //when
    store.dispatch(
      GetAccountSummaryCommandAction(
        user: User(
          session: MockUserSession(),
          attributes: [],
          cognitoUser: MockCognitoUser(),
        ),
        forceAccountSummaryReload: false,
      ),
    );
    //then
    expect((await appState).accountSummaryState, isA<AccountSummaryLoadingState>());
  });

  test("When fetching account summary successful it should update with account summary data", () async{
    //given
    final store = createTestStore(
        accountSummaryService: FakeAccountSummaryService(),
        initialState: createAppState(
          accountSummaryState: AccountSummaryInitialState(),
        )
    );

    final appState = store.onChange.firstWhere((element) => element.accountSummaryState is WithAccountSummaryState);
    //when
    store.dispatch(
      GetAccountSummaryCommandAction(
        user: User(
          session: MockUserSession(),
          attributes: [],
          cognitoUser: MockCognitoUser(),
        ),
        forceAccountSummaryReload: false,
      ),
    );
    //then
    final WithAccountSummaryState accountSummaryState = (await appState).accountSummaryState as WithAccountSummaryState;
    expect(accountSummaryState.accountSummary.id, "id-123445");
  });

  test("When fetching account summary fails it should update with error", () async{
    //given
    final store = createTestStore(
        accountSummaryService: FakeFailingAccountSummaryService(),
        initialState: createAppState(
          accountSummaryState: AccountSummaryInitialState(),
        )
    );

    final appState = store.onChange.firstWhere((element) => element.accountSummaryState is AccountSummaryErrorState);
    //when
    store.dispatch(
      GetAccountSummaryCommandAction(
        user: User(
          session: MockUserSession(),
          attributes: [],
          cognitoUser: MockCognitoUser(),
        ),
        forceAccountSummaryReload: false,
      ),
    );
    //then
    expect((await appState).accountSummaryState, isA<AccountSummaryErrorState>());
  });
}