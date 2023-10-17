import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

AuthState authReducer(AuthState currentState, dynamic action) {
  if (action is AuthLoadingEventAction) {
    return AuthLoadingState(action.loadingType);
  } else if (action is CredentialsLoadedEventAction) {
    return AuthInitialState(
      email: action.email ?? action.email,
      password: action.password ?? action.password,
    );
  } else if (action is AuthFailedEventAction) {
    return AuthErrorState(action.errorType);
  } else if (action is AuthenticatedWithoutBoundDeviceEventAction) {
    return AuthenticatedWithoutBoundDeviceState(action.cognitoUser);
  } else if (action is AuthenticatedWithBoundDeviceEventAction) {
    return AuthenticatedWithBoundDeviceState(action.cognitoUser);
  } else if (action is AuthenticationConfirmedEventAction) {
    return AuthenticatedAndConfirmedState(action.authenticatedUser);
  } else if (action is LoggedOutEventAction) {
    return AuthInitialState();
  }
  return currentState;
}
