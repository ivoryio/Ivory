import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';

class OnboardingProgressMiddleware extends MiddlewareClass<AppState> {
  final OnboardingService _onboardingService;

  OnboardingProgressMiddleware(this._onboardingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (store.state.authState is! AuthenticationInitializedState) {
      return;
    }

    if (action is GetOnboardingProgressCommandAction) {
      final user = (store.state.authState as AuthenticationInitializedState).cognitoUser;

      final response = await _onboardingService.getOnboardingProgress(user: user);

      if (response is OnboardingProgressSuccessResponse) {
        store.dispatch(OnboardingProgressFetchedEvendAction(currentStep: response.currentStep));
      } else {
        store.dispatch(GetOnboardingProgressFailedEventAction());
      }
    }
  }
}
