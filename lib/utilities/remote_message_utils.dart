import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/models/notifications/notification_type.dart';

class RemoteMessageUtils {
  static NotificationType getNotificationType(String type) {
    final Map<String, NotificationType> notificationTypeMap = {
      "BASIC_NOTIFICATION": NotificationType.basicNotification,
      "REPAYMENT_REMINDER": NotificationType.repaymentReminder,
      "SCA_CHALLENGE": NotificationType.scaChallenge,
      "SCORING_SUCCESSFUL": NotificationType.scoringSuccessful,
      "SCORING_FAILED": NotificationType.scoringFailed,
      "SCORING_IN_PROGRESS": NotificationType.scoringInProgress,
    };

    return notificationTypeMap[type] ?? NotificationType.unknown;
  }

  static NotificationTransactionMessage getNotificationTransactionMessage(RemoteMessage message) {
    return NotificationTransactionMessage(
      cardId: message.data["card_id"] as String,
      amountUnit: message.data["amount_unit"] as String,
      amountValue: message.data["amount_value"] as String,
      merchantName: message.data["merchant_name"] as String,
      amountCurrency: message.data["amount_currency"] as String,
      changeRequestId: message.data["change_request_id"] as String,
      declineChangeRequestId: message.data["decline_change_request_id"] as String,
      dateTime: DateTime.parse(message.data["challenged_at"] as String).toLocal(),
    );
  }
}
