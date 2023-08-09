import 'package:redux/redux.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/services/push_notification_service.dart';

import '../../redux/app_state.dart';

class NotificationsMiddleware extends MiddlewareClass<AppState> {
  final PushNotificationService _pushNotificationService;

  NotificationsMiddleware(this._pushNotificationService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AuthLoggedInAction) {
      _pushNotificationService.init(store, user: action.user);
    }
  }
}
