import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/models/user.dart';

class ReceivedTransactionApprovalNotificationEventAction {
  final User user;
  NotificationTransactionMessage message;

  ReceivedTransactionApprovalNotificationEventAction({required this.user, required this.message});
}

class ReceivedScoringSuccessfulNotificationEventAction {}

class ReceivedScoringFailedNotificationEventAction {}

class ResetNotificationCommandAction {}
