import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

class OnboardingPersonalDetailsPresenter {
  static OnboardingPersonalDetailsViewModel presentOnboardingPersonalDetails({
    required OnboardingPersonalDetailsState onboardingPersonalDetailsState,
  }) {
    if (onboardingPersonalDetailsState is OnboardingPersonalDetailsSuggestionsFetchedState) {
      return OnboardingPersonalDetailsFetchedViewModel(
        suggestions: onboardingPersonalDetailsState.suggestions,
      );
    } else if (onboardingPersonalDetailsState is OnboardingPersonalDetailsErrorState) {
      return OnboardingPersonalDetailsErrorViewModel();
    } else if (onboardingPersonalDetailsState is OnboardingPersonalDetailsLoadingState) {
      return OnboardingPersonalDetailsLoadingViewModel();
    } else if (onboardingPersonalDetailsState is OnboardingPersonalDetailsAddressSuggestionSelectedState) {
      return OnboardingPersonalDetailsAddressSuggestionSelectedViewModel(
        selectedSuggestion: onboardingPersonalDetailsState.selectedSuggestion,
      );
    }

    return OnboardingPersonalDetailsInitialViewModel();
  }
}

abstract class OnboardingPersonalDetailsViewModel extends Equatable {
  final List<AddressSuggestion>? suggestions;
  final AddressSuggestion? selectedSuggestion;

  const OnboardingPersonalDetailsViewModel({
    this.suggestions,
    this.selectedSuggestion,
  });

  @override
  List<Object?> get props => [suggestions, selectedSuggestion];
}

class OnboardingPersonalDetailsInitialViewModel extends OnboardingPersonalDetailsViewModel {}

class OnboardingPersonalDetailsLoadingViewModel extends OnboardingPersonalDetailsViewModel {}

class OnboardingPersonalDetailsFetchedViewModel extends OnboardingPersonalDetailsViewModel {
  const OnboardingPersonalDetailsFetchedViewModel({
    required List<AddressSuggestion> suggestions,
  }) : super(suggestions: suggestions);
}

class OnboardingPersonalDetailsAddressSuggestionSelectedViewModel extends OnboardingPersonalDetailsViewModel {
  const OnboardingPersonalDetailsAddressSuggestionSelectedViewModel({
    required AddressSuggestion selectedSuggestion,
  }) : super(selectedSuggestion: selectedSuggestion);
}

class OnboardingPersonalDetailsErrorViewModel extends OnboardingPersonalDetailsViewModel {}
