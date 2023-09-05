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
    // card_id
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
