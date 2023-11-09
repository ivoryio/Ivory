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

    if (action is CreatePersonAccountCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());

        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final personalDetailsAttributes = store.state.onboardingPersonalDetailsState.attributes;

        final response = await _onboardingPersonalDetailsService.createPerson(
          user: user,
          address: personalDetailsAttributes.selectedAddress!,
          birthCity: personalDetailsAttributes.city ?? "",
          birthCountry: personalDetailsAttributes.country ?? "",
          birthDate: personalDetailsAttributes.birthDate ?? "",
          nationality: personalDetailsAttributes.nationality ?? "",
          addressLine: action.addressLine,
        );

        if (response is OnboardingCreatePersonSuccessResponse) {
          store.dispatch(CreatePersonAccountSuccessEventAction(personId: response.personId));
        } else if (response is OnboardingPersonalDetailsServiceErrorResponse) {
          store.dispatch(CreatePersonAccountFailedEventAction(errorType: response.errorType));
        }
      }
    }
  }
}
