import 'package:redux/redux.dart';

import '../../models/transactions/transaction_model.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/bank_card/bank_card_action.dart';
import '../../redux/person/account_summary/account_summay_action.dart';
import '../../redux/transactions/transactions_action.dart';
import '../../redux/transactions/transactions_state.dart';

void forceReloadAppStates(Store<AppState> store, User user) {
  final transactionsState = store.state.transactionsState;
  final filter = (transactionsState is TransactionsFetchedState) ? transactionsState.transactionListFilter:null;

  store.dispatch(
    GetTransactionsCommandAction(filter: filter, forceReloadTransactions: true),
  );

  store.dispatch(GetHomeTransactionsCommandAction(
    filter: const TransactionListFilter(
      size: 3,
      page: 1,
      sort: '-recorded_at',
    ),
    forceReloadTransactions: true,
  ));

  store.dispatch(GetBankCardsCommandAction(forceCardsReload: true));

  store.dispatch(GetAccountSummaryCommandAction(user: user, forceAccountSummaryReload: true));
}