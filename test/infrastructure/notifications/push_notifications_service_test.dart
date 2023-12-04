import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_service.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';
import 'package:solarisdemo/navigator_observers/general_navigation_observer.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/screens/transactions/transaction_approval_pending_screen.dart';

import '../../redux/auth/auth_mocks.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../../setup/platform.dart';
import 'firebase_messaging_mocks.dart';
import 'push_notifications_service_mocks.dart';

void main() {
  setupFirebaseMessagingMocks();

  late FirebaseMessaging messaging;
  late PushNotificationStorageService storageService;
  late Store<AppState> mockStore;
  late MockFlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  setUpAll(() async {
    await Firebase.initializeApp();

    FirebaseMessagingPlatform.instance = mockMessagingPlatform;
    messaging = FirebaseMessaging.instance;
    storageService = MockPushNotificationStorageService();
    mockStore = MockReduxStore();
    flutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
  });

  tearDown(() {
    resetPlatformOverride();
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
      test("When the user denied the permission, isInitialized should be false", () async {
        // given
        when(mockMessagingPlatform.requestPermission()).thenAnswer((_) async => deniedNotificationSettings);

        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);
        final store = createTestStore(initialState: createAppState());

        // when
        await pushNotificationService.init(store);

        // then
        expect(pushNotificationService.isInitialized, false);
      });

      test("When the user granted the permission from iOS platform, isInitialized should be true", () async {
        // given
        setPlatformOverride(TargetPlatform.iOS);

        when(mockMessagingPlatform.requestPermission()).thenAnswer((_) async => authorizedNotificationSettings);
        when(mockMessagingPlatform.setForegroundNotificationPresentationOptions(alert: true, sound: true))
            .thenAnswer((_) async => {});

        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);
        final store = createTestStore(initialState: createAppState());

        // when
        await pushNotificationService.init(store);

        // then
        expect(pushNotificationService.isInitialized, true);
      });
    });

    group("handleSavedNotification", () {
      test("When there is no saved notification, nothing should happen", () async {
        // given
        when(storageService.find()).thenAnswer((_) async => null);

        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);

        // when
        await pushNotificationService.handleSavedNotification();

        // then
        verifyNever(storageService.delete());
      });

      testWidgets("When the notification type is unknown, it should only delete it", (tester) async {
        // given
        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);

        final navigatorKey = GlobalKey<NavigatorState>();
        final navigationObserver = NavigationGeneralObserver();

        pushNotificationService.store = mockStore;
        pushNotificationService.navigatorKey = navigatorKey;
        pushNotificationService.flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;

        when(storageService.find()).thenAnswer(
          (_) async => jsonEncode(MockRemoteMessages.unknownMessageType.toMap()),
        );

        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [navigationObserver],
            navigatorKey: navigatorKey,
            home: Container(),
          ),
        );

        // when
        await pushNotificationService.handleSavedNotification();

        // then
        verify(storageService.delete()).called(1);
        verifyNever(mockStore.dispatch(any));

        expect(navigationObserver.routeStack.last, "/");
      });

      testWidgets(
          "When NotificationType.scaChallenge is saved, the store should dispatch the correct action and redirect to the correct screen",
          (tester) async {
        // given
        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);

        final navigatorKey = GlobalKey<NavigatorState>();
        final navigationObserver = NavigationGeneralObserver();

        pushNotificationService.user = MockUser();
        pushNotificationService.store = mockStore;
        pushNotificationService.navigatorKey = navigatorKey;
        pushNotificationService.flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;

        when(storageService.find()).thenAnswer(
          (_) async => jsonEncode(MockRemoteMessages.scaChallengeMessage.toMap()),
        );

        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [navigationObserver],
            navigatorKey: navigatorKey,
            home: Container(),
            routes: {
              TransactionApprovalPendingScreen.routeName: (context) => Container(),
            },
          ),
        );

        // when
        await pushNotificationService.handleSavedNotification();

        // then
        final dispatch = verify(mockStore.dispatch(captureAny)).captured;

        expect(dispatch.single, isA<ReceivedTransactionApprovalNotificationEventAction>());
        expect(navigationObserver.routeStack.last, TransactionApprovalPendingScreen.routeName);

        verify(storageService.delete()).called(1);
      });

      testWidgets(
          "When NotificationType.scoringSuccessful is saved, the store should dispatch the correct action and redirect to the correct screen",
          (tester) async {
        // given
        final pushNotificationService = FirebasePushNotificationService(storageService: storageService);

        final navigatorKey = GlobalKey<NavigatorState>();
        final navigationObserver = NavigationGeneralObserver();

        pushNotificationService.user = MockUser();
        pushNotificationService.store = mockStore;
        pushNotificationService.navigatorKey = navigatorKey;
        pushNotificationService.flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin;

        when(storageService.find()).thenAnswer(
          (_) async => jsonEncode(MockRemoteMessages.scoringSuccessfulMessage.toMap()),
        );

        await tester.pumpWidget(
          MaterialApp(
            navigatorObservers: [navigationObserver],
            navigatorKey: navigatorKey,
            home: Container(),
            routes: {
              // TODO: OnboardingScoringSuccessfulScreen.routeName: (context) => Container(),
            },
          ),
        );

        // when
        await pushNotificationService.handleSavedNotification();

        // then
        final dispatch = verify(mockStore.dispatch(captureAny)).captured;

        expect(dispatch.single, isA<ReceivedScoringSuccessfulNotificationEventAction>());
        // TODO: expect(navigationObserver.routeStack.last, OnboardingScoringSuccessfulScreen.routeName);

        verify(storageService.delete()).called(1);
      });
    });
  });
}
