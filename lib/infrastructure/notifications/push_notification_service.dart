import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';
import 'package:solarisdemo/models/notifications/notification_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/redux/person/account_summary/account_summay_action.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_pending_screen.dart';
import 'package:solarisdemo/services/api_service.dart';
import 'package:solarisdemo/utilities/remote_message_utils.dart';

import '../../models/transactions/transaction_model.dart';
import '../../redux/app_state.dart';
import '../../redux/transactions/transactions_action.dart';

const String highImportanceChannelId = 'high_importance_channel';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  debugPrint("FCM Background Message Received: ${message.notification?.title}");
  saveNotificationMessage(message);
}

void saveNotificationMessage(RemoteMessage message) async {
  debugPrint("Save notification message");
  await PushNotificationSharedPreferencesStorageService().add(jsonEncode(message.toMap()));
}

abstract class PushNotificationService extends ApiService {
  PushNotificationService({super.user});

  Future<void> init(Store<AppState> store, {User? user});

  Future<bool> hasPermission();

  Future<void> handleSavedNotification();

  Future<void> clearNotification();
}

class FirebasePushNotificationService extends PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  late final Store<AppState> store;
  final PushNotificationStorageService storageService;

  FirebasePushNotificationService({super.user, required this.storageService}) {
    handleAndroidLocalNotifications();
  }

  @override
  Future<void> init(Store<AppState> store, {User? user}) async {
    this.store = store;
    if (user != null) this.user = user;

    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('User declined or has not accepted notifications');
      return;
    }

    // Show notification when app is in foreground
    if (Platform.isIOS) {
      // iOS foreground notifications are handled by the OS
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        sound: true,
      );
    } else {
      // Android foreground notifications are handled by the app
      FirebaseMessaging.onMessage.listen((message) {
        final notification = message.notification;
        final android = message.notification?.android;

        if (notification != null && android != null) {
          FlutterLocalNotificationsPlugin().show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                android.channelId ?? highImportanceChannelId,
                android.channelId ?? highImportanceChannelId,
              ),
            ),
            payload: jsonEncode(message.toMap()),
          );
        }
      });
    }

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage); // App is in background and notification received
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessage); // App was in background and notification clicked
    FirebaseMessaging.instance.getInitialMessage().then(_onMessage); // App was terminated and notification clicked
    FirebaseMessaging.onMessage.listen(_pushNotificationReceived);

    // Handle token
    _messaging.getToken().then(_onTokenRefresh); // Initial token (on app start)
    _messaging.onTokenRefresh.listen(_onTokenRefresh); // Token refresh
  }

  void _onMessage(RemoteMessage? message) {
    if (message == null) return;

    debugPrint('FCM Message received: ${message.toMap().toString()}');

    _redirect(message);
    clearNotification();
  }

  void _pushNotificationReceived(RemoteMessage? message) {
    final transactionsState = store.state.transactionsState;
    final filter = (transactionsState is TransactionsFetchedState) ? transactionsState.transactionListFilter:null;
    store.dispatch(
      GetTransactionsCommandAction(filter: filter, user: user!, forceReloadTransactions: true),
    );
    store.dispatch(GetHomeTransactionsCommandAction(
      filter: const TransactionListFilter(
        size: 3,
        page: 1,
        sort: '-recorded_at',
      ),
      user: user!,
      forceReloadTransactions: true,
    ));
    store.dispatch(GetBankCardsCommandAction(user: user!, forceCardsReload: true));
    store.dispatch(GetAccountSummaryCommandAction(user: user!, forceAccountSummaryReload: true));
  }

  Future<void> handleAndroidLocalNotifications() async {
    if (!Platform.isAndroid) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      highImportanceChannelId,
      highImportanceChannelId,
      importance: Importance.max,
    );
    final androidImplementation = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.initialize(
      const AndroidInitializationSettings('@mipmap/ic_launcher'),
      onDidReceiveNotificationResponse: (response) async {
        // On click handled for our foreground notifications on Android
        if (response.payload == null || response.payload!.isEmpty) return;
        final message = RemoteMessage.fromMap(jsonDecode(response.payload!));
        _onMessage(message);
      },
    );

    await androidImplementation?.createNotificationChannel(channel);
  }

  void _onTokenRefresh(String? token) async {
    debugPrint('FCM Token refreshed: $token');
    if (token == null) return;

    try {
      await post('notifications/token', body: {'token': token}, authNeeded: true);
    } catch (e) {
      log(e.toString());
      throw Exception("Could not update token");
    }
  }

  @override
  Future<bool> hasPermission() async {
    final settings = await _messaging.requestPermission();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  void _redirect(RemoteMessage message) {
    debugPrint("Redirect from notification");
    final context = navigatorKey.currentContext as BuildContext;
    final notificationType = RemoteMessageUtils.getNotificationType(message.data["type"] as String);

    if (notificationType == NotificationType.scaChallenge) {
      store.dispatch(ReceivedTransactionApprovalNotificationEventAction(
        user: user!,
        message: RemoteMessageUtils.getNotificationTransactionMessage(message),
      ));
      Navigator.pushNamed(context, TransactionApprovalPendingScreen.routeName);
    } else {
      debugPrint("Unsupported notification type ${message.data["type"]}");
    }
  }

  @override
  Future<void> handleSavedNotification() async {
    final message = await storageService.find();
    if (message == null) return;

    debugPrint("Redirect from saved notification");

    final notification = RemoteMessage.fromMap(jsonDecode(message));
    _redirect(notification);
    clearNotification();
  }

  @override
  Future<void> clearNotification() async {
    debugPrint("Clear notification");
    await storageService.delete();
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}
