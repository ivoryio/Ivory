import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';

import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingSignupPresenter {
  static OnboardingSignupViewModel present({required OnboardingSignupState signupState, AuthState? authState}) {
    final isAuthenticated = authState != null && authState is AuthenticationInitializedState;
    final isAccountCreated = signupState.isSuccessful == true;
    final isAuthLoading = authState != null && authState is AuthLoadingState;

    return OnboardingSignupViewModel(
      signupAttributes: signupState.signupAttributes,
      isLoading: signupState.isLoading || isAuthLoading,
      isSuccessful: isAccountCreated && isAuthenticated,
      errorType: signupState.errorType,
    );
  }
}

class OnboardingSignupViewModel extends Equatable {
  final OnboardingSignupAttributes signupAttributes;
  final OnboardingSignupErrorType? errorType;
  final bool isLoading;
  final bool? isSuccessful;

  const OnboardingSignupViewModel({
    required this.signupAttributes,
    this.isLoading = false,
    this.isSuccessful = false,
    this.errorType,
  });

  @override
  List<Object?> get props => [signupAttributes, isLoading, isSuccessful, errorType];
}
