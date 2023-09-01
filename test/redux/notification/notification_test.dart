import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/notification/notification_action.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';

import '../../infrastructure/bank_card/bank_card_presenter_test.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
    const MethodChannel('com.thinslices.solarisdemo/native'),
    (call) async {
      if (call.method == 'getDeviceFingerprint') {
        return "deviceFingerprintMock";
      }

      return null;
    },
  );

  SharedPreferences.setMockInitialValues({
    'device_id': "deviceId",
    'device_consent_id': "deviceConsentId",
  });

  const message = NotificationTransactionMessage(
    changeRequestId: "changeRequestId",
    declineChangeRequestId: "declineChangeRequestId",
    amountCurrency: "EUR",
    amountUnit: "cents",
    amountValue: "32",
    merchantName: "KFC",
  );

  test("When received a transaction approval notification the state should update", () async {
    // given
    final store = createTestStore(
      initialState: createAppState(
        notificationState: NotificationInitialState(),
      ),
    );
    final appState = store.onChange.firstWhere(
      (element) => element.notificationState is NotificationTransactionApprovalState,
    );

    // when
    store.dispatch(ReceivedTransactionApprovalNotificationEventAction(user: MockUser(), message: message));

    // then
    expect((await appState).notificationState, isA<NotificationTransactionApprovalState>());
  });

  test("When using the reset command the state should reset to initial", () async {
    // given
    final store = createTestStore(
      initialState: createAppState(
        notificationState: NotificationTransactionApprovalState(message: message),
      ),
    );
    final appState = store.onChange.firstWhere(
      (element) => element.notificationState is NotificationInitialState,
    );

    // when
    store.dispatch(ResetNotificationCommandAction());

    // then
    expect((await appState).notificationState, isA<NotificationInitialState>());
  });
}
