import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/device_fingerprint_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

class AuthMiddleware extends MiddlewareClass<AppState> {
  final AuthService _authService;
  final DeviceService _deviceService;
  final DeviceFingerprintService _deviceFingerprintService;
  final PersonService _personService;

  AuthMiddleware(this._authService, this._deviceService, this._deviceFingerprintService, this._personService);
  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is AuthenticateUserCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final userName = action.email.isNotEmpty ? action.email : action.phoneNumber;

      final loginResponse = await _authService.login(
        userName,
        action.password,
      );
      if (loginResponse is! LoginSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
      }

      await _deviceService.saveCredentialsInCache(
        action.email,
        action.password,
      );

      String? consentId = await _deviceService.getConsentId();

      if (consentId == null) {
        final newConsentResponse =
            await _deviceFingerprintService.createDeviceConsent(user: (loginResponse as LoginSuccessResponse).user);

        if (newConsentResponse is! CreateDeviceConsentResponse) {
          store.dispatch(AuthFailedEventAction());
        }

        consentId = (newConsentResponse as CreateDeviceConsentResponse).consentId;

        final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
        if (deviceFingerprint == null) {
          store.dispatch(AuthFailedEventAction());
        }
        await _deviceFingerprintService.createDeviceActivity(
            activityType: DeviceActivityType.CONSENT_PROVIDED, deviceFingerprint: deviceFingerprint!);
      }

      final deviceFingerprint = await _deviceFingerprintService.getDeviceFingerprint(consentId);
      if (deviceFingerprint == null) {
        store.dispatch(AuthFailedEventAction());
      }
      await _deviceFingerprintService.createDeviceActivity(
          activityType: DeviceActivityType.APP_START, deviceFingerprint: deviceFingerprint!);

      store.dispatch(AuthenticatedEventAction(cognitoUser: (loginResponse as LoginSuccessResponse).user));
    }

    if (action is ConfirmAuthenticationCommandAction) {
      store.dispatch(AuthLoadingEventAction());

      final personResponse = await _personService.getPerson();
      if (personResponse is! GetPersonSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
      }

      final personAccountResponse = await _personService.getPersonAccount();
      if (personAccountResponse is! GetPersonAccountSuccessResponse) {
        store.dispatch(AuthFailedEventAction());
      }

      final authenticatedUser = AuthenticatedUser(
        person: (personResponse as GetPersonSuccessResponse).person,
        cognito: (store.state.authState as AuthenticatedState).cognitoUser,
        personAccount: (personAccountResponse as GetPersonAccountSuccessResponse).personAccount,
      );

      store.dispatch(AuthenticationConfirmedEventAction(authenticatedUser: authenticatedUser));
      action.onSuccess();
    }
  }
}
