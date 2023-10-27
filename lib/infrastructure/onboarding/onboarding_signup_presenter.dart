import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel presentSignupAttributes({required OnboardingSignupSubmittedState signupState}) {
    return OnboardingSignupSubmittedViewModel(
      signupAttributes: OnboardingSignupAttributes(
        email: signupState.email,
        password: signupState.password,
        firstName: signupState.firstName,
        lastName: signupState.lastName,
        pushNotificationsAllowed: signupState.notificationsAllowed,
        title: signupState.title,
        tsAndCsSignedAt: signupState.tsAndCsSignedAt,
      ),
    );
  }

  static OnboardingSignupViewModel presentNotification({required OnboardingSignupSubmittedState signupState}) {
    if (signupState.notificationsAllowed != null) {
      if (signupState.notificationsAllowed == true) {
        return NotificationsPermissionAllowedViewModel();
      } else if (signupState.notificationsAllowed == false) {
        return NotificationsPermissionNotAllowedViewModel();
      }
    }

    return OnboardingSignupInitialViewModel();
  }
}

abstract class OnboardingSignupViewModel extends Equatable {
  final OnboardingSignupAttributes? signupAttributes;

  const OnboardingSignupViewModel({this.signupAttributes});

  @override
  List<Object?> get props => [signupAttributes];
}

class OnboardingSignupInitialViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionNotAllowedViewModel extends OnboardingSignupViewModel {}

class NotificationsPermissionUnknownViewModel extends OnboardingSignupViewModel {}

class OnboardingSignupSubmittedViewModel extends OnboardingSignupViewModel {
  const OnboardingSignupSubmittedViewModel({super.signupAttributes});
}
