import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';

class OnboardingPersonalDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingPersonalDetailsService _onboardingPersonalDetailsService;

  OnboardingPersonalDetailsMiddleware(this._onboardingPersonalDetailsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is CreatePersonCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final response = await _onboardingPersonalDetailsService.createPerson(user: user);

        if (response is OnboardingCreatePersonSuccessResponse) {
          store.dispatch(CreatePersonSuccessEventAction(personId: response.personId));
        } else if (response is OnboardingPersonalDetailsServiceErrorResponse) {
          store.dispatch(CreatePersonFailedEventAction(errorType: response.errorType));
        }
      }
    }
  }
}
