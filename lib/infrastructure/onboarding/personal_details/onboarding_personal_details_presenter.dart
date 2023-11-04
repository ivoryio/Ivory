import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

class OnboardingPersonalDetailsPresenter {
  static OnboardingPersonalDetailsViewModel presentOnboardingPersonalDetails({
    required OnboardingPersonalDetailsState onboardingPersonalDetailsState,
  }) {
    return OnboardingPersonalDetailsViewModel();
  }
}

class OnboardingPersonalDetailsViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}
