import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:local_auth/local_auth.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_service.dart';
import 'package:solarisdemo/infrastructure/categories/categories_service.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/credit_line/credit_line_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_service.dart';
import 'package:solarisdemo/infrastructure/repayments/more_credit/more_credit_service.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

import '../config.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await dotenv.load();
  ClientConfigData clientConfig = ClientConfig.getClientConfig();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final store = _buildStore();

  runApp(IvoryApp(
    clientConfig: clientConfig,
    store: store,
  ));
}

Store<AppState> _buildStore() {
  final store = createStore(
    initialState: AppState.initialState(),
    pushNotificationService: FirebasePushNotificationService(
      storageService: PushNotificationSharedPreferencesStorageService(),
    ),
    transactionService: TransactionService(),
    creditLineService: CreditLineService(),
    repaymentReminderService: RepaymentReminderService(),
    cardApplicationService: CardApplicationService(),
    billService: BillService(),
    moreCreditService: MoreCreditService(),
    bankCardService: BankCardService(),
    categoriesService: CategoriesService(),
    personService: PersonService(),
    transferService: TransferService(),
    changeRequestService: ChangeRequestService(),
    deviceBindingService: DeviceBindingService(),
    deviceService: DeviceService(),
    biometricsService: BiometricsService(
      auth: LocalAuthentication(),
    ),
    deviceInfoService: DeviceInfoService(),
  );

  return store;
}
