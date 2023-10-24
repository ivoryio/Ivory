import 'package:redux/src/store.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';

class FakePushNotificationService extends PushNotificationService {
  @override
  Future<void> clearNotification() async {}

  @override
  Future<void> handleSavedNotification() async {}

  @override
  void handleTokenRefresh({User? user}) {}

  @override
  Future<bool> hasPermission() async {
    return true;
  }

  @override
  Future<void> init(Store<AppState> store) async {}
}
