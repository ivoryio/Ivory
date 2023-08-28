import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
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
  BankCardService? bankCardService,
  CategoriesService? categoriesService,
  PersonService? personService,
  TransferService? transferService,
  ChangeRequestService? changeRequestService,
}) {
  return createStore(
    initialState: initialState,
    pushNotificationService: pushNotificationService ?? NotImplementedPushNotificationService(),
    transactionService: transactionService ?? NotImplementedTransactionService(),
    creditLineService: creditLineService ?? NotImplementedCreditLineService(),
    repaymentReminderService: repaymentReminderService ?? NotImplementedRepaymentReminderService(),
    billService: billService ?? NotImplementedBillService(),
    bankCardService: bankCardService ?? NotImplementedBankCardService(),
    categoriesService: categoriesService ?? NotImplementedCategoriesService(),
    personService: personService ?? NotImplementedPersonService(),
    transferService: transferService ?? NotImplementedTransferService(),
    changeRequestService: changeRequestService ?? NotImplementedChangeRequestService(),
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

class NotImplementedBankCardService extends BankCardService {
  @override
  Future<BankCardServiceResponse> getBankCardById({User? user, String? cardId}) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> activateBankCard({User? user, String? cardId}) {
    throw UnimplementedError();
  }
}

class NotImplementedCategoriesService extends CategoriesService {
  @override
  Future<CategoriesServiceResponse> getCategories({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedPersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<PersonServiceResponse> getPersonAccount({User? user}) {
    throw UnimplementedError();
  }
}

class NotImplementedTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmTransferChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) {
    throw UnimplementedError();
  }
}
