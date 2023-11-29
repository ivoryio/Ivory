import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/notifications/push_notification_storage_service.dart';

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
      returnValue: Future<String>.value(''),
      returnValueForMissingStub: Future<String>.value(''),
    );
  }
}
