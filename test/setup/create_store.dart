import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';

Store<AppState> createTestStore({
  required AppState initialState,
  PushNotificationService? pushNotificationService,
  TransactionService? transactionService,
  CreditLineService? creditLineService,
  RepaymentReminderService? repaymentReminderService,
  BillService? billService,
  MoreCreditService? moreCreditService,
  BankCardService? bankCardService,
  CategoriesService? categoriesService,
}) {
  return createStore(
    initialState: initialState,
    pushNotificationService:
        pushNotificationService ?? NotImplementedPushNotificationService(),
    transactionService:
        transactionService ?? NotImplementedTransactionService(),
    creditLineService: creditLineService ?? NotImplementedCreditLineService(),
    repaymentReminderService:
        repaymentReminderService ?? NotImplementedRepaymentReminderService(),
    billService: billService ?? NotImplementedBillService(),
    moreCreditService: moreCreditService ?? NotImplementedMoreCreditService(),
    bankCardService: bankCardService ?? NotImplementedBankCardService(),
    categoriesService: categoriesService ?? NotImplementedCategoriesService(),
  );
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

class NotImplementedTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions(
      {TransactionListFilter? filter, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedCreditLineService extends CreditLineService {
  @override
  Future<CreditLineServiceResponse> getCreditLine({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedRepaymentReminderService extends RepaymentReminderService {
  @override
  Future<RepaymentReminderServiceResponse> getRepaymentReminders({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedBillService extends BillService {
  @override
  Future<BillServiceResponse> getBills({User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<BillServiceResponse> getBillById({required String id, User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedMoreCreditService extends MoreCreditService {
  @override
  Future<MoreCreditServiceResponse> addToWaitlist({
    User? user,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById(
      {User? user, String? cardId}) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> activateBankCard(
      {User? user, String? cardId}) {
    throw UnimplementedError();
  }
}

class NotImplementedCategoriesService extends CategoriesService {
  @override
  Future<CategoriesServiceResponse> getCategories({User? user}) {
    throw UnimplementedError();
  }
}
