import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';

abstract class OnboardingPersonalDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingPersonalDetailsInitialState extends OnboardingPersonalDetailsState {}

class OnboardingPersonalDetailsLoadingState extends OnboardingPersonalDetailsState {}

class OnboardingPersonalDetailsErrorState extends OnboardingPersonalDetailsState {}

class OnboardingPersonalDetailsSuggestionsFetchedState extends OnboardingPersonalDetailsState {
  final List<AddressSuggestion> suggestions;

  OnboardingPersonalDetailsSuggestionsFetchedState(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class OnboardingPersonalDetailsAddressSuggestionSelectedState extends OnboardingPersonalDetailsState {
  final AddressSuggestion selectedSuggestion;

  OnboardingPersonalDetailsAddressSuggestionSelectedState(this.selectedSuggestion);

  @override
  List<Object?> get props => [selectedSuggestion];
}
