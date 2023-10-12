import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

AuthState authReducer(AuthState currentState, dynamic action) {
  if (action is AuthLoadingEventAction) {
    return AuthLoadingState();
  } else if (action is AuthFailedEventAction) {
    return AuthErrorState();
  } else if (action is AuthenticatedEventAction) {
    return AuthenticatedState(action.cognitoUser);
  } else if (action is AuthenticationConfirmedEventAction) {
    return AuthenticatedAndConfirmedState(action.authenticatedUser);
  }
  return currentState;
}
