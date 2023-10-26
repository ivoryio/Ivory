import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel presentSignup({required OnboardingSignupSubmittedState signupState}) {
    if (_allPropertiesNotNull(signupState)) {
      if (signupState.notificationsAllowed == true) {
        return NotificationsPermissionAllowedViewModel();
      } else if (signupState.notificationsAllowed == false && _allPropertiesNotNull(signupState)) {
        return NotificationsPermissionNotAllowedViewModel();
      }

      return OnboardingPasswordSubmittedViewModel(password: signupState.password!);
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
  final String? password;

  const OnboardingSignupViewModel({
    this.password,
  });

  @override
  List<Object?> get props => [password];
}

class OnboardingSignupInitialViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionNotAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionUnknownViewModel extends OnboardingSignupViewModel {}

class OnboardingPasswordSubmittedViewModel extends OnboardingSignupViewModel {
  const OnboardingPasswordSubmittedViewModel({
    required String password,
  }) : super(password: password);
}
