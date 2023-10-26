import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel presentSignup({required OnboardingSignupSubmittedState signupState}) {
    log('1 - In presenter [$signupState]');

    if (_allPropertiesNotNull(signupState)) {
      if (signupState.notificationsAllowed == true) {
        return NotificationsPermissionAllowedViewModel();
      } else if (signupState.notificationsAllowed == false) {
        return NotificationsPermissionNotAllowedViewModel();
      }
      log('2 - In presenter [$signupState]');
      return OnboardingSignupSubmittedViewModel(password: signupState.password as OnboardingSignupAttributes);
    }

    log('3 - In presenter [$signupState]');
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
  final OnboardingSignupAttributes? signupAttributes;

  const OnboardingSignupViewModel({
    this.signupAttributes,
  });

  @override
  List<Object?> get props => [signupAttributes];
}

class OnboardingSignupInitialViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionNotAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionUnknownViewModel extends OnboardingSignupViewModel {}

class OnboardingSignupSubmittedViewModel extends OnboardingSignupViewModel {
  const OnboardingSignupSubmittedViewModel({required OnboardingSignupAttributes password})
      : super(signupAttributes: password);
}
