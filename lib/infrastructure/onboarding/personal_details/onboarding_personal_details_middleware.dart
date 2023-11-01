import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';

class OnboardingPersonalDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingService _onboardingService;

  OnboardingPersonalDetailsMiddleware(this._onboardingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is FetchOnboardingPersonalDetailsAddressSuggestionsCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(OnboardingPersonalDetailsLoadingEventAction());
        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final response = await _onboardingService.getAddressSuggestions(
          user: user,
          queryString: action.queryString,
        );

        if (response is OnboardingGetAddressSuggestionsSuccessResponse) {
          store.dispatch(
              OnboardingPersonalDetailsAddressSuggestionsFetchedEventAction(suggestions: response.suggestions));
        } else {
          store.dispatch(OnboardingPersonalDetailFetchingAddressSuggestionsFailedEventAction);
        }
      }
    }

    if (action is SelectOnboardingPersonalDetailsAddressSuggestionCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        store.dispatch(
          OnboardingPersonalDetailsAddressSuggestionSelectedEventAction(selectedSuggestion: action.selectedSuggestion),
        );
      }
    }
  }
}
