import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/store_factory.dart';
import 'package:solarisdemo/services/push_notification_service.dart';

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
    transactionService: TransactionService(),
    pushNotificationService: FirebasePushNotificationService(),
  );

  return store;
}
