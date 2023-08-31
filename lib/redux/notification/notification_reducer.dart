import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';

NotificationState notificationReducer(NotificationState currentState, dynamic action) {
  if (action is ReceivedTransactionApprovalNotificationEventAction) {
    return NotificationTransactionApprovalState(message: action.message);
  } else if (action is ResetNotificationCommandAction) {
    return NotificationInitialState();
  }

  return currentState;
}
