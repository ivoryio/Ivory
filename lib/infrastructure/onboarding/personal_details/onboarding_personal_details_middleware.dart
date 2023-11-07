import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';

class OnboardingPersonalDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingPersonalDetailsService _onboardingPersonalDetailsService;

  OnboardingPersonalDetailsMiddleware(this._onboardingPersonalDetailsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is SaveAddressOfResidenceCommandAction) {
      store.dispatch(OnboardingPersonalDetailsLoadingEventAction());
    }
  }
}
