import 'package:local_auth/local_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/utilities/crypto/crypto_key_generator.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

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
  PersonService? personService,
  TransferService? transferService,
  ChangeRequestService? changeRequestService,
  DeviceBindingService? deviceBindingService,
  DeviceService? deviceService,
  BiometricsService? biometricsService,
  DeviceInfoService? deviceInfoService,
}) {
  return createStore(
    initialState: initialState,
    pushNotificationService: pushNotificationService ?? NotImplementedPushNotificationService(),
    transactionService: transactionService ?? NotImplementedTransactionService(),
    creditLineService: creditLineService ?? NotImplementedCreditLineService(),
    repaymentReminderService: repaymentReminderService ?? NotImplementedRepaymentReminderService(),
    billService: billService ?? NotImplementedBillService(),
    moreCreditService: moreCreditService ?? NotImplementedMoreCreditService(),
    bankCardService: bankCardService ?? NotImplementedBankCardService(),
    categoriesService: categoriesService ?? NotImplementedCategoriesService(),
    personService: personService ?? NotImplementedPersonService(),
    transferService: transferService ?? NotImplementedTransferService(),
    changeRequestService: changeRequestService ?? NotImplementedChangeRequestService(),
    deviceBindingService: deviceBindingService ?? NotImplementedDeviceBindingService(),
    deviceService: deviceService ?? NotImplementedDeviceService(),
    biometricsService: biometricsService ?? NotImplementedBiometricsService(),
    deviceInfoService: deviceInfoService ?? NotImplementedDeviceInfoService(),
  );
}

class NotImplementedDeviceInfoService extends DeviceInfoService {
  @override
  Future<String> getDeviceName() {
    throw UnimplementedError();
  }
}

class NotImplementedPushNotificationService extends PushNotificationService {
  @override
  Future<void> init(Store<AppState> store, {User? user}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPermission() {
    throw UnimplementedError();
  }

  @override
  Future<void> handleSavedNotification() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearNotification() {
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

class NotImplementedMoreCreditService extends MoreCreditService {
  @override
  Future<MoreCreditServiceResponse> changeWaitlistStatus({
    User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<MoreCreditServiceResponse> getWaitlistStatus({
    User? user,
  }) {
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

  @override
  Future<BankCardServiceResponse> createBankCard({
    required User? user,
    required CreateBankCardReqBody reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> freezeCard({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> unfreezeCard({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> getLatestPinKey({
    required String cardId,
    required User? user,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> changePin({
    required String cardId,
    required User? user,
    required ChangePinRequestBody reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<BankCardServiceResponse> getBankCards({User? user}) {
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

class NotImplementedDeviceBindingService extends DeviceBindingService {
  @override
  Future<DeviceBindingServiceResponse> createDeviceBinding({
    required User user,
    required CreateDeviceBindingRequest reqBody,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<DeviceBindingServiceResponse> verifyDeviceBindingSignature(
      {required User user, required String deviceId, required String deviceFingerPrint, required String signature}) {
    throw UnimplementedError();
  }

  @override
  Future<DeviceBindingServiceResponse> createRestrictedKey({
    required User user,
    required CreateRestrictedKeyRequest reqBody,
  }) {
    throw UnimplementedError();
  }
}

class NotImplementedDeviceService extends DeviceService {
  @override
  Future<String?> getConsentId() async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceId() async {
    throw UnimplementedError();
  }

  @override
  Future<String?> getDeviceFingerprint(String? consentId) async {
    throw UnimplementedError();
  }

  @override
  Future<DeviceKeyPairs?> getDeviceKeyPairs({bool restricted = false}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveKeyPairIntoCache({
    required DeviceKeyPairs keyPair,
    bool restricted = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveDeviceIdIntoCache(String deviceId) async {
    throw UnimplementedError();
  }

  @override
  DeviceKeyPairs? generateECKey() {
    throw UnimplementedError();
  }

  @override
  RSAKeyPair? generateRSAKey() {
    throw UnimplementedError();
  }

  @override
  String? generateSignature({required String privateKey, required String stringToSign}) {
    throw UnimplementedError();
  }
}

class MockLocalAutentication extends Mock implements LocalAuthentication {}

class NotImplementedBiometricsService extends BiometricsService {
  NotImplementedBiometricsService() : super(auth: MockLocalAutentication());
}
