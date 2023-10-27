import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';

import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel present({required OnboardingSignupState signupState}) {
    return OnboardingSignupViewModel(signupAttributes: signupState.signupAttributes);
  }
}

class OnboardingSignupViewModel extends Equatable {
  final OnboardingSignupAttributes signupAttributes;

  const OnboardingSignupViewModel({required this.signupAttributes});

  bool? get notificationsAllowed => signupAttributes.notificationsAllowed;

  @override
  List<Object?> get props => [signupAttributes];
}
