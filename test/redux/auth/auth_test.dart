import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

import '../../setup/create_app_state.dart';
import '../../setup/create_store.dart';
import '../notification/notification_mocks.dart';
import '../person/person_mocks.dart';
import '../transactions/transaction_mocks.dart';
import 'auth_mocks.dart';

void main() {
  setUp(() async {
    final Map<String, Object> values = <String, Object>{
      'deviceId': 'deviceId',
      'email': 'email',
      'password': 'password',
      'consents':
          '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
    };
    SharedPreferences.setMockInitialValues(values);

    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('com.thinslices.solarisdemo/native');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getDeviceFingerprint') {
        return 'mockDeviceFingerPrint';
      }
      return null;
    });
  });
  group("Loading credentials", () {
    test(
      "Loading existing user credentials should return credemtials loaded state",
      () async {
        //given

        final store = createTestStore(
          deviceService: FakeDeviceService(),
          initialState: createAppState(
            authState: AuthInitialState(),
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
        final appState = store.onChange.firstWhere((element) => element.authState is AuthCredentialsLoadedState);

        //when
        store.dispatch(LoadCredentialsCommandAction());

        //then
        expect((await loadingState).authState, isA<AuthLoadingState>());
        expect((await appState).authState, isA<AuthCredentialsLoadedState>());
      },
    );

    test(
      "Loading non-existing credentials should reset to initial state",
      () async {
        //given
        final store = createTestStore(
          deviceService: FakeFailingDeviceService(),
          initialState: createAppState(
            authState: AuthInitialState(),
          ),
        );

        final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
        final appState = store.onChange.firstWhere((element) => element.authState is AuthInitialState);

        //when
        store.dispatch(LoadCredentialsCommandAction());

        //then
        expect((await loadingState).authState, isA<AuthLoadingState>());
        expect((await appState).authState, isA<AuthInitialState>());
      },
    );
  });
  group("Init Authentication", () {
    test("Should authenticate the user without bound device succesfully", () async {
      final Map<String, Object> values = <String, Object>{
        'deviceId': '',
        'email': 'email',
        'password': 'password',
        'consents':
            '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
      };
      SharedPreferences.setMockInitialValues(values);
      TestWidgetsFlutterBinding.ensureInitialized();

      //given
      final store = createTestStore(
        deviceService: FakeDeviceServiceWithNoDeviceId(),
        authService: FakeAuthService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        deviceBindingService: FakeDeviceBindingService(),
        deviceInfoService: FakeDeviceInfoService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) => element.authState is AuthenticationInitializedState);

      //when
      store.dispatch(
        InitUserAuthenticationCommandAction(email: "email", password: "password"),
      );

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthenticationInitializedState>());
      expect(((await appState).authState as AuthenticationInitializedState).authType, equals(AuthType.withTan));
    });

    test("Should authenticate the user with bound device succesfully", () async {
      final Map<String, Object> values = <String, Object>{
        'deviceId': 'deviceId',
        'email': 'email',
        'password': 'password',
        'consents':
            '{"65511707812e1584dffb74e836979e64cper":"87f95560750da154915773f9c5cf10a1dcon","d6aecc5590eae1d5bf4611b028363aeecper":"d5f8d15f0851efb54c31ae61a4d35491dcon"}',
      };
      SharedPreferences.setMockInitialValues(values);
      TestWidgetsFlutterBinding.ensureInitialized();

      //given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        authService: FakeAuthService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        deviceBindingService: FakeDeviceBindingService(),
        deviceInfoService: FakeDeviceInfoService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) => element.authState is AuthenticationInitializedState);

      //when
      store.dispatch(
        InitUserAuthenticationCommandAction(email: "email", password: "password"),
      );

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthenticationInitializedState>());
      expect(((await appState).authState as AuthenticationInitializedState).authType, equals(AuthType.withBiometrics));
    });

    test("If credentials are invalid should fail with AuthErrorType.invalidCredentials", () async {
      //given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        authService: FakeFailingAuthService(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) =>
          element.authState is AuthErrorState &&
          (element.authState as AuthErrorState).errorType == AuthErrorType.invalidCredentials);

      //when
      store.dispatch(
        InitUserAuthenticationCommandAction(email: "", password: ""),
      );

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthErrorState>());
      expect(((await appState).authState as AuthErrorState).errorType, equals(AuthErrorType.invalidCredentials));
    });

    test("When user group is onboarding it should return AuthenticationInitializedState with authType onboarding",
        () async {
      //given
      final store = createTestStore(
        deviceService: FakeDeviceService(),
        authService: FakeAuthServiceWithOnboardingUser(),
        deviceFingerprintService: FakeDeviceFingerprintService(),
        deviceBindingService: FakeDeviceBindingService(),
        deviceInfoService: FakeDeviceInfoService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) => element.authState is AuthenticationInitializedState);

      //when
      store.dispatch(
        InitUserAuthenticationCommandAction(email: "email@example.com", password: "123456"),
      );

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthenticationInitializedState>());
      expect(((await appState).authState as AuthenticationInitializedState).authType, AuthType.onboarding);
    });
  });

  group("Authenticate", () {
    test("Succesfully confirm authentication with a bound device (with biometrics), should return AuthenticatedState",
        () async {
      //given
      final store = createTestStore(
        personService: FakePersonService(),
        biometricsService: FakeBiometricsService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) => element.authState is AuthenticatedState);

      //when
      store.dispatch(AuthenticateUserCommandAction(
        tan: '',
        authType: AuthType.withBiometrics,
        cognitoUser: MockUser(),
        onSuccess: () {},
      ));

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthenticatedState>());
      expect(((await appState).authState as AuthenticatedState).authType, equals(AuthType.withBiometrics));
    });
    test("If biometrics are not confirmed, should fail with AuthErrorType.biometricAuthFailed ", () async {
      //given
      final store = createTestStore(
        personService: FakePersonService(),
        biometricsService: FakeFailingBiometricsService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) =>
          element.authState is AuthErrorState &&
          (element.authState as AuthErrorState).errorType == AuthErrorType.biometricAuthFailed);

      //when
      store.dispatch(AuthenticateUserCommandAction(
        authType: AuthType.withBiometrics,
        tan: '',
        cognitoUser: MockUser(),
        onSuccess: () {},
      ));

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthErrorState>());
      expect(((await appState).authState as AuthErrorState).errorType, equals(AuthErrorType.biometricAuthFailed));
    });

    test("Succesfully confirm authentication without a bound device (only with OTP), should return AuthenticatedState",
        () async {
      //given
      final store = createTestStore(
        personService: FakePersonService(),
        pushNotificationService: FakeNotificationService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) => element.authState is AuthenticatedState);

      //when
      store.dispatch(AuthenticateUserCommandAction(
        authType: AuthType.withTan,
        tan: '',
        cognitoUser: MockUser(),
        onSuccess: () {},
      ));

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthenticatedState>());
      expect(((await appState).authState as AuthenticatedState).authType, equals(AuthType.withTan));
    });

    test("If getPerson is not responding with data, should fail with AuthErrorType.cantGetPersonData", () async {
      //given
      final store = createTestStore(
        personService: FakeFailingPersonService(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );
      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) =>
          element.authState is AuthErrorState &&
          (element.authState as AuthErrorState).errorType == AuthErrorType.cantGetPersonData);

      //when
      store.dispatch(AuthenticateUserCommandAction(
        authType: AuthType.withTan,
        tan: '123456',
        cognitoUser: MockUser(),
        onSuccess: () {},
      ));

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthErrorState>());
      expect(((await appState).authState as AuthErrorState).errorType, equals(AuthErrorType.cantGetPersonData));
    });
    test("If getPersonAccount is not responding with data, should fail with AuthErrorType.cantGetPersonAccountData",
        () async {
      //given
      final store = createTestStore(
        personService: FakePersonServiceWithFailingGetPersonAccount(),
        initialState: createAppState(
          authState: AuthInitialState(),
        ),
      );

      final loadingState = store.onChange.firstWhere((element) => element.authState is AuthLoadingState);
      final appState = store.onChange.firstWhere((element) =>
          element.authState is AuthErrorState &&
          (element.authState as AuthErrorState).errorType == AuthErrorType.cantGetPersonAccountData);

      //when
      store.dispatch(AuthenticateUserCommandAction(
        authType: AuthType.withTan,
        tan: '123456',
        cognitoUser: MockUser(),
        onSuccess: () {},
      ));

      //then
      expect((await loadingState).authState, isA<AuthLoadingState>());
      expect((await appState).authState, isA<AuthErrorState>());
      expect(((await appState).authState as AuthErrorState).errorType, equals(AuthErrorType.cantGetPersonAccountData));
    });
  });
}
