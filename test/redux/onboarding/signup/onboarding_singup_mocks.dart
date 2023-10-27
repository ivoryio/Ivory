import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';

class FakeNotificationService extends PushNotificationService {
  @override
  Future<void> init(Store<AppState> store) {
    return Future.value();
  }

  @override
  Future<void> clearNotification() {
    return Future.value();
  }

  @override
  Future<void> handleSavedNotification() {
    return Future.value();
  }

  @override
  void handleTokenRefresh({User? user}) {
    return;
  }

  @override
  Future<bool> hasPermission() {
    return Future.value(true);
  }
}

class FakeNotificationServiceWithNoPermission extends PushNotificationService {
  @override
  Future<void> init(Store<AppState> store) {
    return Future.value();
  }

  @override
  Future<void> clearNotification() {
    return Future.value();
  }

  @override
  Future<void> handleSavedNotification() {
    return Future.value();
  }

  @override
  void handleTokenRefresh({User? user}) {
    return;
  }

  @override
  Future<bool> hasPermission() {
    return Future.value(false);
  }
}
