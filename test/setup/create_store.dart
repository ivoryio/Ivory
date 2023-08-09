import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/services/push_notification_service.dart';

Store<AppState> createTestStore({
  required AppState initialState,
  TransactionService? transactionService,
  PushNotificationService? pushNotificationService,
}) {
  return createStore(
    initialState: initialState,
    transactionService: transactionService ?? NotImplementedTransactionService(),
    pushNotificationService: pushNotificationService ?? NotImplementedPushNotificationService(),
  );
}

class NotImplementedTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({TransactionListFilter? filter, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedPushNotificationService extends PushNotificationService {
  @override
  void init(Store<AppState> store, {User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPermission() {
    throw UnimplementedError();
  }
}
