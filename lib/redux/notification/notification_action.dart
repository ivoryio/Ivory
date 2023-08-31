import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';

class ReceivedTransactionApprovalNotificationEventAction {
  NotificationTransactionMessage message;

  ReceivedTransactionApprovalNotificationEventAction({required this.message});
}

class ResetNotificationCommandAction {}
