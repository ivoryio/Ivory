import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

AuthState authReducer(AuthState currentState, dynamic action) {
  if (action is AuthLoadingEventAction) {
    return AuthLoadingState();
  } else if (action is CredentialsLoadedEventAction) {
    return AuthCredentialsLoadedState(
      email: action.email ?? action.email,
      password: action.password ?? action.password,
      deviceId: action.deviceId ?? action.deviceId,
    );
  } else if (action is AuthFailedEventAction) {
    return AuthErrorState(action.errorType);
  } else if (action is AuthenticatedWithoutBoundDeviceEventAction) {
    return AuthenticatedWithoutBoundDeviceState(action.cognitoUser);
  } else if (action is AuthenticatedWithBoundDeviceEventAction) {
    return AuthenticatedWithBoundDeviceState(action.cognitoUser);
  } else if (action is AuthenticationConfirmedEventAction) {
    return AuthenticatedAndConfirmedState(action.authenticatedUser);
  } else if (action is ResetAuthEventAction) {
    return AuthInitialState();
  }
  return currentState;
}
