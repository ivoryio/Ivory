import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/device_binding.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

import '../../setup/authentication_helper.dart';
import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';

import 'device_mocks.dart';

void main() {
  final authState = AuthStatePlaceholder.loggedInState();

  setUp(() async {
    SharedPreferences.setMockInitialValues(
      {
        'consents':
            '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
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
          authState: authState,
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingCreatedState);
      // when
      store.dispatch(
        CreateDeviceBindingCommandAction(),
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingErrorState);
      // when
      store.dispatch(
        CreateDeviceBindingCommandAction(),
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
          authState: authState,
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingDeletedState);
      // when
      store.dispatch(
        DeleteBoundDeviceCommandAction(deviceId: 'deviceId'),
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingErrorState);
      // when
      store.dispatch(
        DeleteBoundDeviceCommandAction(deviceId: 'deviceId'),
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
          authState: authState,
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingChallengeVerifiedState);
      // when
      store.dispatch(
        VerifyDeviceBindingSignatureCommandAction(tan: '212212'),
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
          authState: authState,
        ),
      );
      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingVerificationErrorState);
      // when
      store.dispatch(
        VerifyDeviceBindingSignatureCommandAction(tan: '111222'),
      );
      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingVerificationErrorState>());
    });
  });

  group('Fetch bound devices', () {
    test('When fetching bound devices succesfully, should return a lust of devices', () async {
      //given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
          authState: authState,
        ),
      );

      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingFetchedState);

      //when
      store.dispatch(
        FetchBoundDevicesCommandAction(),
      );

      //then
      expect((await appState).deviceBindingState, isA<DeviceBindingFetchedState>());
      expect(((await appState).deviceBindingState as DeviceBindingFetchedState).devices.length, 2);
    });
  });

  test('When fetching bound devices fails, should return error with empty list', () async {
    //given
    final store = createTestStore(
      deviceBindingService: FakeFailingDeviceBindingService(),
      deviceService: FakeDeviceService(),
      deviceInfoService: FakeDeviceInfoService(),
      initialState: createAppState(
        deviceBindingState: DeviceBindingInitialState(),
        authState: authState,
      ),
    );

    final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingFetchedState);

    //when
    store.dispatch(
      FetchBoundDevicesCommandAction(),
    );

    //then
    expect((await appState).deviceBindingState, isA<DeviceBindingFetchedState>());
    expect(((await appState).deviceBindingState as DeviceBindingFetchedState).devices.length, 0);
  });

  group('Check if binding is possible', () {
    test('When checking if binding is possible succesfully, should return true', () async {
      //given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        biometricsService: FakeBiometricsService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingFetchedState(devices, devices[0], false, false),
          authState: authState,
        ),
      );

      final appState = store.onChange.skip(1).firstWhere((element) =>
          element.deviceBindingState is DeviceBindingFetchedState &&
          (element.deviceBindingState as DeviceBindingFetchedState).isBindingPossible == true);

      //when
      store.dispatch(
        DeviceBindingCheckIfPossibleCommandAction(),
      );

      //then
      expect((await appState).deviceBindingState, isA<DeviceBindingFetchedState>());
      expect(((await appState).deviceBindingState as DeviceBindingFetchedState).isBindingPossible, true);
    });

    test('When binding is not possible because of biometrics, should return the proper state', () async {
      //given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        biometricsService: FakeFailingBiometricsService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingFetchedState(devices, devices[0], false, false),
          authState: authState,
        ),
      );

      final appState = store.onChange.firstWhere((element) =>
          element.deviceBindingState is DeviceBindingNotPossibleState &&
          (element.deviceBindingState as DeviceBindingNotPossibleState).reason ==
              DeviceBindingNotPossibleReason.noBiometricsAvailable);

      //when
      store.dispatch(
        DeviceBindingCheckIfPossibleCommandAction(),
      );

      //then
      expect((await appState).deviceBindingState, isA<DeviceBindingNotPossibleState>());
      expect(((await appState).deviceBindingState as DeviceBindingNotPossibleState).reason,
          DeviceBindingNotPossibleReason.noBiometricsAvailable);
    });

    test('When binding is not possible because it was already tried in the last 5 minutes, should return proper state',
        () async {
      //given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        deviceService: FakeFailingDeviceService(),
        deviceInfoService: FakeDeviceInfoService(),
        biometricsService: FakeBiometricsService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingFetchedState(devices, devices[0], false, false),
          authState: authState,
        ),
      );

      final appState = store.onChange.firstWhere((element) =>
          element.deviceBindingState is DeviceBindingNotPossibleState &&
          (element.deviceBindingState as DeviceBindingNotPossibleState).reason ==
              DeviceBindingNotPossibleReason.alreadyTriedInLast5Minutes);

      //when
      store.dispatch(
        DeviceBindingCheckIfPossibleCommandAction(),
      );

      //then
      expect((await appState).deviceBindingState, isA<DeviceBindingNotPossibleState>());
      expect(((await appState).deviceBindingState as DeviceBindingNotPossibleState).reason,
          DeviceBindingNotPossibleReason.alreadyTriedInLast5Minutes);
    });
  });
}
