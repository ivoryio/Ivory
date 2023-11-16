import 'package:redux/redux.dart';
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

    if (action is AuthenticationInitializedEventAction) {
      await _pushNotificationService.init(store);
      _pushNotificationService.handleTokenRefresh(user: action.cognitoUser);
      await _pushNotificationService.handleSavedNotification();
    }

    if (action is ReceivedTransactionApprovalNotificationEventAction) {
      store.dispatch(AuthorizeTransactionCommandAction(
        changeRequestId: action.message.changeRequestId,
      ));
    }
  }
}
