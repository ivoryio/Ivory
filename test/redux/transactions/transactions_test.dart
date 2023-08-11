import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

import '../../cubits/login_cubit_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'transactions_mocks.dart';

void main() {
  test("When asking to fetch transactions the first time you enter the screen it should have a loading state", () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsLoadingState);
    //when
    store.dispatch(GetTransactionsCommandAction(
        filter: null,
        user: User(
            session: MockUserSession(),
            attributes: [],
            cognitoUser: MockCognitoUser(),
        ),
    ),);
    //then
    expect((await appState).transactionsState, isA<TransactionsLoadingState>());
  });

  test("When fetching transactions successfully should update with transactions", () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsFetchedState);
    //when
    store.dispatch(GetTransactionsCommandAction(
      filter: null,
      user: User(
        session: MockUserSession(),
        attributes: [],
        cognitoUser: MockCognitoUser(),
      ),
    ),);
    //then
    final TransactionsFetchedState transactionsState = (await appState).transactionsState as TransactionsFetchedState;
    expect(transactionsState.transactions, hasLength(2));
  });

  test("When fetching transactions is failing should update with error", () async {
    //given
    final store = createTestStore(
      transactionService: FakeFailingTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsErrorState);
    //when
    store.dispatch(GetTransactionsCommandAction(
      filter: null,
      user: User(
        session: MockUserSession(),
        attributes: [],
        cognitoUser: MockCognitoUser(),
      ),
    ),);
    //then
    expect((await appState).transactionsState, isA<TransactionsErrorState>());
  });
}