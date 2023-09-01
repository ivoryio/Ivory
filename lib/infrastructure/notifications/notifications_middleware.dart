import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_action.dart';

import '../../redux/app_state.dart';

class NotificationsMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationService _pushNotificationService;

  NotificationsMiddleware(this._pushNotificationService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AuthLoggedInAction) {
      await _pushNotificationService.init(store, user: action.user);
      await _pushNotificationService.handleSavedNotification();
    }

    if (action is ReceivedTransactionApprovalNotificationEventAction) {
      final consentId = await DeviceService.getDeviceConsentId();

      final deviceId = await DeviceService.getDeviceIdFromCache();

      final deviceData = await DeviceService.getDeviceFingerprint(consentId);

      if (deviceId == null || deviceData == null) {
        return;
      }

      store.dispatch(TransactionApprovalRequestChallengeCommandAction(
        user: action.user,
        changeRequestId: action.message.changeRequestId,
        deviceData: deviceData,
        deviceId: deviceId,
      ));
    }
  }
}
