import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

class OnboardingPersonalDetailsPresenter {
  static OnboardingPersonalDetailsViewModel presentOnboardingPersonalDetails({
    required OnboardingPersonalDetailsState onboardingPersonalDetailsState,
  }) {
    return OnboardingPersonalDetailsViewModel(
      attributes: onboardingPersonalDetailsState.attributes,
      isLoading: onboardingPersonalDetailsState.isLoading,
      tanRequestedAt: onboardingPersonalDetailsState.tanRequestedAt,
      isAddressSaved: onboardingPersonalDetailsState.isAddressSaved,
      isMobileConfirmed: onboardingPersonalDetailsState.isMobileConfirmed,
      errorType: onboardingPersonalDetailsState.errorType,
    );
  }
}

class OnboardingPersonalDetailsViewModel extends Equatable {
  final OnboardingPersonalDetailsAttributes attributes;
  final bool isLoading;
  final DateTime? tanRequestedAt;
  final bool? isAddressSaved;
  final bool? isMobileConfirmed;
  final OnboardingPersonalDetailsErrorType? errorType;

  const OnboardingPersonalDetailsViewModel({
    required this.attributes,
    this.isLoading = false,
    this.tanRequestedAt,
    this.isAddressSaved,
    this.isMobileConfirmed,
    this.errorType,
  });

  @override
  List<Object?> get props => [];
}
