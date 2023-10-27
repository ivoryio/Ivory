import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';

class OnboardingSignupState extends Equatable {
  final OnboardingSignupAttributes signupAttributes;
  final bool isLoading;
  final bool hasError;

  OnboardingSignupState({
    this.signupAttributes = const OnboardingSignupAttributes(),
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  List<Object?> get props => [signupAttributes, isLoading, hasError];
}
