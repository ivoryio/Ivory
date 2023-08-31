import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/models/notifications/notification_type.dart';

class RemoteMessageUtils {
  static NotificationType getNotificationType(String type) {
    switch (type) {
      case "BASIC_NOTIFICATION":
        return NotificationType.basicNotification;
      case "REPAYMENT_REMINDER":
        return NotificationType.repaymentReminder;
      case "SCA_CHALLENGE":
        return NotificationType.scaChallenge;
      default:
        throw Exception("Unsupported notification type");
    }
  }

  static NotificationTransactionMessage getNotificationTransactionMessage(RemoteMessage message) {
    return NotificationTransactionMessage(
      merchantName: message.data["merchant_name"] as String,
      amountValue: message.data["amount_value"] as String,
      amountCurrency: message.data["amount_currency"] as String,
      amountUnit: message.data["amount_unit"] as String,
      changeRequestId: message.data["change_request_id"] as String,
      declineChangeRequestId: message.data["decline_change_request_id"] as String,
    );
  }
}
