import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';

class FetchOnboardingPersonalDetailsAddressSuggestions {
  final String queryString;

  FetchOnboardingPersonalDetailsAddressSuggestions({required this.queryString});
}

class SelectOnboardingPersonalDetailsAddressSuggestionCommandAction {
  final AddressSuggestion selectedSuggestion;

  SelectOnboardingPersonalDetailsAddressSuggestionCommandAction({required this.selectedSuggestion});
}

class OnboardingPersonalDetailsAddressSuggestionsFetchedEventAction {
  final List<AddressSuggestion> suggestions;

  OnboardingPersonalDetailsAddressSuggestionsFetchedEventAction({required this.suggestions});
}

class OnboardingPersonalDetailsAddressSuggestionSelectedEventAction {
  final AddressSuggestion selectedSuggestion;

  OnboardingPersonalDetailsAddressSuggestionSelectedEventAction({required this.selectedSuggestion});
}

class OnboardingPersonalDetailsLoadingEventAction {}

class OnboardingPersonalDetailFetchingAddressSuggestionsFailedEventAction {}
