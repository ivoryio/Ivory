import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:redux/redux.dart';

import '../redux/app_state.dart';

abstract class PushNotificationService {
  Future<String> getToken();

  Future<void> redirectFromSavedPendingNotification();

  void clearNotification();
}

class FirebasePushNotificationService extends PushNotificationService {
  final _messaging = FirebaseMessaging.instance;
  final Store<AppState> store;

  FirebasePushNotificationService(this.store) {}

  @override
  Future<String> getToken() {
    throw UnimplementedError();
  }

  @override
  Future<void> redirectFromSavedPendingNotification() {
    throw UnimplementedError();
  }

  @override
  void clearNotification() {}
}
