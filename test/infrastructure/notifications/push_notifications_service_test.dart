import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'firebase_messaging_mocks.dart';
import 'push_notifications_service_mocks.dart';

void main() {
  setupFirebaseMessagingMocks();

  late FirebaseMessaging messaging;
  late PushNotificationStorageService storageService;

  setUpAll(() async {
    await Firebase.initializeApp();

    FirebaseMessagingPlatform.instance = mockMessagingPlatform;
    messaging = FirebaseMessaging.instance;
    storageService = MockPushNotificationStorageService();
  });

  group('FirebaseMessaging instance', () {
    test('returns an instance', () async {
      expect(messaging, isA<FirebaseMessaging>());
    });

    test('returns the correct $FirebaseApp', () {
      expect(messaging.app, isA<FirebaseApp>());
      expect(messaging.app.name, defaultFirebaseAppName);
    });
  });

  group('PushNotificationService', () {
    group("init", () {
      test("When the user denied the permission, the service should not be initialized", () async {
        // given
        when(mockMessagingPlatform.requestPermission()).thenAnswer((_) async => deniedNotificationSettings);

        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);
        final store = createTestStore(initialState: createAppState());

        // when
        await pushNotificationService.init(store);

        // then
        expect(pushNotificationService.isInitialized, false);
      });
    });
  });
}
