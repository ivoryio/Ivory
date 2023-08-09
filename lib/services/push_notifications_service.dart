import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

import '../redux/app_state.dart';

const String _channelId = 'high_importance_channel';

@pragma('vm:entry-point')
Future<void> _onBackgroundMessage(RemoteMessage message) async {
  debugPrint("FCM Background Message Received: ${message.notification?.title}");
}

abstract class PushNotificationService extends ApiService {
  PushNotificationService({super.user});

  void init(Store<AppState> store, {User? user});

  Future<bool> hasPermission();
}

class FirebasePushNotificationService extends PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  late final Store<AppState> store;

  FirebasePushNotificationService({super.user}) {
    handleAndroidLocalNotifications();
  }

  @override
  void init(Store<AppState> store, {User? user}) async {
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
      FirebaseMessaging.onMessage.listen(_onMessage);
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
                android.channelId ?? _channelId,
                android.channelId ?? _channelId,
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

    // Handle token
    _messaging.getToken().then(_onTokenRefresh); // Initial token (on app start)
    _messaging.onTokenRefresh.listen(_onTokenRefresh); // Token refresh
  }

  void _onMessage(RemoteMessage? message) {
    if (message == null) return;

    debugPrint('FCM Message received: ${message.toMap().toString()}');
  }

  Future<void> handleAndroidLocalNotifications() async {
    if (!Platform.isAndroid) return;

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelId,
      importance: Importance.max,
    );
    final androidImplementation = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.initialize(
      const AndroidInitializationSettings('@mipmap/ic_launcher'),
      onDidReceiveNotificationResponse: (response) async {
        // On click handled for our foreground notifications on Android
        if (response.payload == null) return;
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
}
