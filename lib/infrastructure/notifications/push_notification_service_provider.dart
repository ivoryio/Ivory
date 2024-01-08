import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';

class PushNotificationServiceProvider {
  PushNotificationServiceProvider._();

  static final PushNotificationServiceProvider instance = PushNotificationServiceProvider._();

  late PushNotificationService _service;

  factory PushNotificationServiceProvider.init(PushNotificationService service) {
    instance._service = service;
    return instance;
  }

  PushNotificationService get service => _service;
}
