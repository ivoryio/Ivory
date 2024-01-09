import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';
import 'package:solarisdemo/redux/app_state.dart';

class MockReduxStore extends Mock implements Store<AppState> {
  @override
  dynamic dispatch(dynamic action) => super.noSuchMethod(Invocation.method(#dispatch, [action]));
}

class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {
  @override
  Future<void> cancelAll() async {
    return super.noSuchMethod(
      Invocation.method(#cancelAll, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }
}

class MockPushNotificationStorageService extends Mock implements PushNotificationStorageService {
  @override
  Future<void> add(String jsonMessageData) {
    return super.noSuchMethod(
      Invocation.method(#add, [jsonMessageData]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Future<void> delete() {
    return super.noSuchMethod(
      Invocation.method(#delete, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value(),
    );
  }

  @override
  Future<String?> find() {
    return super.noSuchMethod(
      Invocation.method(#find, []),
      returnValue: Future<String>.value('{}'),
      returnValueForMissingStub: Future<String>.value('{}'),
    );
  }
}

class MockRemoteMessages {
  static RemoteMessage unknownMessageType = const RemoteMessage(data: {
    'type': 'UNKNOWN_TYPE',
  });

  static RemoteMessage scaChallengeMessage = const RemoteMessage(data: {
    'type': 'SCA_CHALLENGE',
    'card_id': 'card_id',
    'amount_unit': 'amount_unit',
    'amount_value': 'amount_value',
    'merchant_name': 'merchant_name',
    'amount_currency': 'amount_currency',
    'change_request_id': 'change_request_id',
    'decline_change_request_id': 'decline_change_request_id',
    'challenged_at': '2023-12-04T00:00:00.000Z',
  });

  static RemoteMessage scoringSuccessfulMessage = const RemoteMessage(data: {
    'type': 'SCORING_SUCCESSFUL',
  });

  static RemoteMessage scoringFailedMessage = const RemoteMessage(data: {
    'type': 'SCORING_FAILED',
  });

  static RemoteMessage scoringInProgressMessage = const RemoteMessage(data: {
    'type': 'SCORING_IN_PROGRESS',
  });
}
