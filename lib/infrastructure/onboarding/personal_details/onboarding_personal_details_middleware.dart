import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/redux/app_state.dart';

class OnboardingPersonalDetailsMiddleware extends MiddlewareClass<AppState> {
  final OnboardingService _onboardingService;

  OnboardingPersonalDetailsMiddleware(this._onboardingService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  }
}
