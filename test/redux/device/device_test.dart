import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';

import 'device_mocks.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(
      {
        'device_consent_id': '081b61238d922568fa94dd685688a9e1dcon',
        'unrestrictedKeyPair':
            '{"publicKey":"0440796c6f7921fb8c4c4604f87c7f93e424eec8d97b82611d211566d7f6c27c7f457d5bff4e44280525d9aa321a9aebf0e886845a98aa5ef91d8ccc92eb370e73","privateKey":"8da5191565a42676508fc1bfa6bd9b8c7790944bf15be915de3c19bc241b64c1"}',
        'restrictedKeyPair':
            '{"publicKey":"047df76da16889ce02ee8ebb19cd02c429fbc04642883fc33d057cbe1c5b30733b3e51d4cb7bda834ff3db8b071c72e18bb96bb5257f93746e0286f04c38bb3b4c","privateKey":"8fd52be93fdfacafcf2fec39ca6483340ead732f6b1480cac58d4fedb2aef0b6"}',
        'device_id': 'a1f9e6c1-1045-4d54-8381-ff9dd4142e88'
      },
    );

    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('com.thinslices.solarisdemo/native');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getDeviceFingerprint') {
        return 'mockDeviceFingerPrint';
      }
      return null;
    });
  });
  group('Creating device binding', () {
    test('When creating device binding successfully should be succesful', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        deviceInfoService: FakeDeviceInfoService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingCreatedState);
      // when
      store.dispatch(
        CreateDeviceBindingCommandAction(user: MockUser()),
      );

      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingCreatedState>());
    });

    test('When creating device binding is failing should update with error', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeFailingDeviceBindingService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingErrorState);
      // when
      store.dispatch(
        CreateDeviceBindingCommandAction(user: MockUser()),
      );
      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingErrorState>());
    });
  });

  group('Deleting device binding', () {

    test('When deleting device binding successfully should be succesful', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingDeletedState);
      // when
      store.dispatch(
        DeleteBoundDeviceCommandAction(user: MockUser(), deviceId: 'deviceId'),
      );

      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingDeletedState>());
    });

    test('When deleting device binding is failing should update with error', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeFailingDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingErrorState);
      // when
      store.dispatch(
        DeleteBoundDeviceCommandAction(user: MockUser(), deviceId: 'deviceId'),
      );
      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingErrorState>());
    });
  });

  group("Verifying device binding", () {
    test('When verifying device binding successfully should be succesful', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingChallengeVerifiedState);
      // when
      store.dispatch(
        VerifyDeviceBindingSignatureCommandAction(user: MockUser(), tan: '212212'),
      );

      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingChallengeVerifiedState>());
    });

    test('When verifying device binding is failing should update with error', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeFailingDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingErrorState);
      // when
      store.dispatch(
        VerifyDeviceBindingSignatureCommandAction(user: MockUser(), tan: '212212'),
      );
      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingErrorState>());
    });
  });
}
