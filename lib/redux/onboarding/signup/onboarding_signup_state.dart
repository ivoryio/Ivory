import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';

class OnboardingSignupState extends Equatable {
  final OnboardingSignupAttributes signupAttributes;
  final OnboardingSignupErrorType? errorType;
  final bool isLoading;
  final bool? isSuccessful;

  const OnboardingSignupState({
    this.signupAttributes = const OnboardingSignupAttributes(),
    this.isLoading = false,
    this.isSuccessful,
    this.errorType,
  });

  @override
  List<Object?> get props => [signupAttributes, isLoading, errorType, isSuccessful];
}
