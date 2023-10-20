import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel presentSignup({required OnboardingSignupState state}) {
    if (state is OnboardingSignupSubmittedState && _allPropertiesNotNull(state)) {
      if (state.notificationsAllowed == true) {
        return OnboardingSignupNotificationsAllowedViewModel();
      } else if (state.notificationsAllowed == false) {
        return OnboardingSignupNotificationsNotAllowedViewModel();
      }
    }
    return OnboardingSignupInitialViewModel();
  }
}

bool _allPropertiesNotNull(OnboardingSignupSubmittedState state) {
  return state.firstName != null &&
      state.lastName != null &&
      state.notificationsAllowed != null &&
      state.password != null &&
      state.title != null &&
      state.email != null;
}

abstract class OnboardingSignupViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingSignupInitialViewModel extends OnboardingSignupViewModel {}

class OnboardingSignupNotificationsAllowedViewModel extends OnboardingSignupViewModel {}

class OnboardingSignupNotificationsNotAllowedViewModel extends OnboardingSignupViewModel {}
