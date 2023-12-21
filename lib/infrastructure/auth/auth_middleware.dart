import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_binding_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/auth/auth_user_group.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/utilities/device_info/device_info.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthService _authService;
  final DeviceService _deviceService;
  final DeviceBindingService _deviceBindingService;
  final DeviceFingerprintService _deviceFingerprintService;
  final DeviceInfoService _deviceInfoService;
  final PersonService _personService;
  final BiometricsService _biometricsService;

  AuthMiddleware(
    this._authService,
    this._deviceService,
    this._deviceBindingService,
    this._deviceFingerprintService,
    this._deviceInfoService,
    this._personService,
    this._biometricsService,
  );
  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is LoadCredentialsCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final credentials = await _deviceService.getCredentialsFromCache();
      if (credentials != null && (credentials.email?.isEmpty ?? true) || (credentials?.password?.isEmpty ?? true)) {
        store.dispatch(ResetAuthEventAction());
        return;
      } else {
        store.dispatch(
          CredentialsLoadedEventAction(
            deviceId: credentials!.deviceId,
            email: credentials.email,
            password: credentials.password,
          ),
        );
      }
    }

    if (action is InitUserAuthenticationCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      if (action.email.isEmpty || action.email == '') {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.invalidCredentials));
        return;
      }

      final loginResponse = await _authService.login(
        action.email,
        action.password,
      );
      if (loginResponse is! LoginSuccessResponse) {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.invalidCredentials));
        return;
      }

      final user = loginResponse.user;

      await _deviceService.saveCredentialsInCache(
        action.email,
        action.password,
      );

      if (loginResponse.user.userGroup == CognitoUserGroup.registering) {
        store.dispatch(AuthenticationInitializedEventAction(
          cognitoUser: user,
          authType: AuthType.onboarding,
          boundDevices: List<Device>.empty(growable: true),
          thisDevice: Device(
            deviceId: '',
            deviceName: await _deviceInfoService.getDeviceName(),
          ),
        ));
        return;
      }

      String? consentId = await _deviceService.getConsentId(user.personId!);

      if (consentId == null) {
        final newConsentResponse = await _deviceFingerprintService.createDeviceConsent(user: user);

        if (newConsentResponse is! CreateDeviceConsentResponse) {
          store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantCreateConsent));
          return;
        }

        consentId = (newConsentResponse).consentId;
        await _deviceService.saveConsentIdInCache(consentId, user.personId!);

        final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
        if (deviceFingerprint == null) {
          store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantCreateFingerprint));
          return;
        }
        final deviceActivity = await _deviceFingerprintService.createDeviceActivity(
          activityType: DeviceActivityType.CONSENT_PROVIDED,
          deviceFingerprint: deviceFingerprint,
        );
        if (deviceActivity is! CreateDeviceActivityResponse) {
          store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantCreateActivity));
          return;
        }
      }

      final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null) {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantCreateFingerprint));
        return;
      }
      final deviceActivity = await _deviceFingerprintService.createDeviceActivity(
        activityType: DeviceActivityType.APP_START,
        deviceFingerprint: deviceFingerprint,
        user: user,
      );
      if (deviceActivity is! CreateDeviceActivityResponse) {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantCreateActivity));
        return;
      }

      final getBoundDevicesResponse = await _deviceBindingService.getDeviceBinding(
        user: user,
      );

      final cachedDeviceId = await _deviceService.getDeviceId();
      Device? boundDevice;
      List<Device> boundDevices = List<Device>.empty(growable: true);

      if (cachedDeviceId != '') {
        if (getBoundDevicesResponse is GetDeviceBindingSuccessResponse) {
          boundDevices = getBoundDevicesResponse.devices;

          for (final device in boundDevices) {
            if (device.deviceId == cachedDeviceId) {
              boundDevice = device;
              break;
            }
          }
        }
      }

      store.dispatch(AuthenticationInitializedEventAction(
        cognitoUser: user,
        authType: boundDevice != null ? AuthType.withBiometrics : AuthType.withTan,
        thisDevice: boundDevice ??
            Device(
              deviceId: '',
              deviceName: await _deviceInfoService.getDeviceName(),
            ),
        boundDevices: boundDevices,
      ));
    }

    if (action is AuthenticateUserCommandAction) {
      store.dispatch(
        AuthLoadingEventAction(),
      );

      if (action.authType == AuthType.withBiometrics) {
        final biometricAuth =
            await _biometricsService.authenticateWithBiometrics(message: "Please use biometric to authenticate");

        if (biometricAuth != true) {
          store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.biometricAuthFailed));
          return;
        }
      }

      final personResponse = await _personService.getPerson(user: action.cognitoUser);
      if (personResponse is! GetPersonSuccessResponse) {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantGetPersonData));
        return;
      }

      final personAccountResponse = await _personService.getPersonAccount(user: action.cognitoUser);
      if (personAccountResponse is! GetPersonAccountSuccessResponse) {
        store.dispatch(AuthFailedEventAction(errorType: AuthErrorType.cantGetPersonAccountData));
        return;
      }

      final authenticatedUser = AuthenticatedUser(
        person: personResponse.person,
        cognito: action.cognitoUser,
        personAccount: personAccountResponse.personAccount,
      );

      store.dispatch(AuthenticatedEventAction(
        authenticatedUser: authenticatedUser,
        authType: action.authType,
      ));
      action.onSuccess();
    }

    if (action is LogoutUserCommandAction) {
      store.dispatch(ResetAuthEventAction());
    }
  }
}
