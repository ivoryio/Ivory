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
}
