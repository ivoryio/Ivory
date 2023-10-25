import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/redux/transactions/transactions_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

import '../../setup/authentication_helper.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'transaction_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

  test("When asking to fetch transactions the first time you enter the screen it should have a loading state",
      () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsLoadingState);
    //when
    store.dispatch(
      GetTransactionsCommandAction(
        filter: null,
        forceReloadTransactions: false,
      ),
    );
    //then
    expect((await appState).transactionsState, isA<TransactionsLoadingState>());
  });

  test("When fetching transactions successfully should update with transactions", () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsFetchedState);
    //when
    store.dispatch(
      GetTransactionsCommandAction(
        filter: null,
        forceReloadTransactions: false,
      ),
    );
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
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsErrorState);
    //when
    store.dispatch(
      GetTransactionsCommandAction(
        filter: null,
        forceReloadTransactions: false,
      ),
    );
    //then
    expect((await appState).transactionsState, isA<TransactionsErrorState>());
  });

  test("When asking to fetch upcoming transactions the first time you enter the screen it should have a loading state",
      () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.transactionsState is TransactionsLoadingState);
    //when
    store.dispatch(
      GetUpcomingTransactionsCommandAction(
        filter: null,
      ),
    );
    //then
    expect((await appState).transactionsState, isA<TransactionsLoadingState>());
  });

  test("When fetching upcoming transactions successfully should update with transactions", () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState =
        store.onChange.firstWhere((element) => element.transactionsState is UpcomingTransactionsFetchedState);
    //when
    store.dispatch(
      GetUpcomingTransactionsCommandAction(
        filter: null,
      ),
    );
    //then
    final UpcomingTransactionsFetchedState transactionsState =
        (await appState).transactionsState as UpcomingTransactionsFetchedState;
    expect(transactionsState.upcomingTransactions, hasLength(2));
  });

  test("When asking to fetch transactions on the home screen the first time you enter the screen it should have a loading state",
          () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        homePageTransactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.homePageTransactionsState is TransactionsLoadingState);
    //when
    store.dispatch(
      GetHomeTransactionsCommandAction(
        filter: const TransactionListFilter(
          size: 3,
          page: 1,
          sort: '-recorded_at',
        ),
        forceReloadTransactions: false,
      ),
    );
    //then
    expect((await appState).homePageTransactionsState, isA<TransactionsLoadingState>());
  });

  test("When fetching home page transactions successfully should update with transactions", () async {
    //given
    final store = createTestStore(
      transactionService: FakeTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.homePageTransactionsState is TransactionsFetchedState);
    //when
    store.dispatch(
      GetHomeTransactionsCommandAction(
        filter: const TransactionListFilter(
          size: 3,
          page: 1,
          sort: '-recorded_at',
        ),
        forceReloadTransactions: false,
      ),
    );
    //then
    final TransactionsFetchedState transactionsState = (await appState).homePageTransactionsState as TransactionsFetchedState;
    expect(transactionsState.transactions, hasLength(2));
  });

  test("When fetching home page transactions is failing should update with error", () async {
    //given
    final store = createTestStore(
      transactionService: FakeFailingTransactionService(),
      initialState: createAppState(
        transactionsState: TransactionsInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.homePageTransactionsState is TransactionsErrorState);
    //when
    store.dispatch(
      GetHomeTransactionsCommandAction(
        filter: const TransactionListFilter(
          size: 3,
          page: 1,
          sort: '-recorded_at',
        ),
        forceReloadTransactions: false,
      ),
    );
    //then
    expect((await appState).homePageTransactionsState, isA<TransactionsErrorState>());
  });
}
