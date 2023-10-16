import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthService _authService;
  final DeviceService _deviceService;
  final DeviceFingerprintService _deviceFingerprintService;
  final PersonService _personService;
  final BiometricsService _biometricsService;

  AuthMiddleware(
    this._authService,
    this._deviceService,
    this._deviceFingerprintService,
    this._personService,
    this._biometricsService,
  );
  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is LoadCredentialsCommandAction) {
      store.dispatch(AuthLoadingEventAction(
        loadingType: AuthLoadingType.initAuth,
      ));

      final credentials = await _deviceService.getCredentialsFromCache();
      if (credentials == null) {
        store.dispatch(
          CredentialsLoadedEventAction(
            email: '',
            password: '',
          ),
        );
        return;
      }

      store.dispatch(
        CredentialsLoadedEventAction(
          email: credentials.email!,
          password: credentials.password!,
        ),
      );
    }

    if (action is AuthenticateUserCommandAction) {
      store.dispatch(AuthLoadingEventAction(
        loadingType: AuthLoadingType.authenticate,
      ));

      final userName = action.email.isNotEmpty ? action.email : action.phoneNumber;

      final loginResponse = await _authService.login(
        userName,
        action.password,
      );
      if (loginResponse is! LoginSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
        return;
      }

      final user = loginResponse.user;

      await _deviceService.saveCredentialsInCache(
        action.email,
        action.password,
      );

      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        final newConsentResponse = await _deviceFingerprintService.createDeviceConsent(user: user);

        if (newConsentResponse is! CreateDeviceConsentResponse) {
          store.dispatch(AuthFailedEventAction());
          return;
        }

        consentId = (newConsentResponse).consentId;

        final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
        if (deviceFingerprint == null) {
          store.dispatch(AuthFailedEventAction());
          return;
        }
        await _deviceFingerprintService.createDeviceActivity(
          activityType: DeviceActivityType.CONSENT_PROVIDED,
          deviceFingerprint: deviceFingerprint,
        );
      }

      final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null) {
        store.dispatch(AuthFailedEventAction());
        return;
      }
      await _deviceFingerprintService.createDeviceActivity(
        activityType: DeviceActivityType.APP_START,
        deviceFingerprint: deviceFingerprint,
        user: user,
      );

      final boundDeviceId = await _deviceService.getDeviceId();
      if (boundDeviceId!.isNotEmpty) {
        store.dispatch(AuthenticatedWithBoundDeviceEventAction(cognitoUser: user));
        return;
      }
      store.dispatch(AuthenticatedWithoutBoundDeviceEventAction(cognitoUser: user));
    }

    if (action is ConfirmTanAuthenticationCommandAction || action is ConfirmBiometricAuthenticationCommandAction) {
      store.dispatch(
        AuthLoadingEventAction(
          loadingType: action is ConfirmTanAuthenticationCommandAction
              ? AuthLoadingType.confirmWithTan
              : AuthLoadingType.confirmWithBiometrics,
        ),
      );

      if (action is ConfirmBiometricAuthenticationCommandAction) {
        final biometricAuth =
            await _biometricsService.authenticateWithBiometrics(message: "Please use biometric to authenticate");

        if (biometricAuth != true) {
          store.dispatch(AuthFailedEventAction());
          return;
        }
      }

      final personResponse = await _personService.getPerson(user: action.cognitoUser);
      if (personResponse is! GetPersonSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
        return;
      }

      final personAccountResponse = await _personService.getPersonAccount(user: action.cognitoUser);
      if (personAccountResponse is! GetPersonAccountSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
        return;
      }

      final authenticatedUser = AuthenticatedUser(
        person: personResponse.person,
        cognito: action.cognitoUser,
        personAccount: personAccountResponse.personAccount,
      );

      store.dispatch(AuthenticationConfirmedEventAction(authenticatedUser: authenticatedUser));
      action.onSuccess();
    }

    if (action is LogoutUserCommandAction) {
      store.dispatch(LoggedOutEventAction());
    }
  }
}
