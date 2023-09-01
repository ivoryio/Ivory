import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/redux/device/device_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import 'device_mocks.dart';

void main() {
  group('Creating device binding', () {
    test('When creating device binding successfully should be succesful', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeDeviceBindingService(),
        initialState: createAppState(
          deviceBindingState: DeviceBindingInitialState(),
        ),
      );

      final loadingState =
          store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingLoadingState);
      final appState = store.onChange.firstWhere((element) => element.deviceBindingState is DeviceBindingFetchedState);
      // when
      store.dispatch(
        CreateDeviceBindingCommandAction(user: MockUser()),
      );

      // then
      expect((await loadingState).deviceBindingState, isA<DeviceBindingLoadingState>());
      expect((await appState).deviceBindingState, isA<DeviceBindingFetchedState>());
    });

    test('When creating device binding is failing should update with error', () async {
      // given
      final store = createTestStore(
        deviceBindingService: FakeFailingDeviceBindingService(),
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
}
