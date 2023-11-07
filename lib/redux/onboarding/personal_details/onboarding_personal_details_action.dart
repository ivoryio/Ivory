import 'package:solarisdemo/models/suggestions/address_suggestion.dart';

class SubmitOnboardingBirthInfoCommandAction {
  final String birthDate;
  final String country;
  final String city;
  final String nationality;

  SubmitOnboardingBirthInfoCommandAction({
    required this.birthDate,
    required this.country,
    required this.city,
    required this.nationality,
  });
}

class SelectOnboardingAddressSuggestionCommandAction {
  final AddressSuggestion suggestion;

  SelectOnboardingAddressSuggestionCommandAction({required this.suggestion});
}

class SaveAddressOfResidenceCommandAction {}

class OnboardingPersonalDetailsLoadingEventAction {}
