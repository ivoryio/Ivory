import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';

class OnboardingProgressMiddleware extends MiddlewareClass<AppState> {
  final OnboardingService _onboardingService;

  OnboardingProgressMiddleware(this._onboardingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetOnboardingProgressCommandAction) {
      if (store.state.authState is AuthenticationInitializedState) {
        final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;
        final response = await _onboardingService.getOnboardingProgress(user: user);

        if (response is OnboardingProgressSuccessResponse) {
          store.dispatch(OnboardingProgressFetchedEvendAction(step: response.step));
        } else {
          store.dispatch(GetOnboardingProgressFailedEventAction());
        }
      } else {
        store.dispatch(OnboardingProgressFetchedEvendAction(step: OnboardingStep.start));
      }
    }
  }
}
