import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';

Store<AppState> createTestStore({
  required AppState initialState,
  TransactionService? transactionService,
  CreditLineService? creditLineService,
  PushNotificationService? pushNotificationService,
}) {
  return createStore(
    initialState: initialState,
    transactionService: transactionService ?? NotImplementedTransactionService(),
    creditLineService: creditLineService ?? NotImplementedCreditLineService(),
    pushNotificationService: pushNotificationService ?? NotImplementedPushNotificationService(),
  );
}

class NotImplementedTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({TransactionListFilter? filter, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedCreditLineService extends CreditLineService {
  @override
  Future<CreditLineServiceResponse> getCreditLine({User? user}) {
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
