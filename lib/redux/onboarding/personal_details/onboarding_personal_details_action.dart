import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
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

class CreatePersonCommandAction {}

class OnboardingPersonalDetailsLoadingEventAction {}

class CreatePersonSuccessEventAction {
  final String personId;

  CreatePersonSuccessEventAction({required this.personId});
}

class CreatePersonFailedEventAction {
  final OnboardingPersonalDetailsErrorType errorType;

  CreatePersonFailedEventAction({required this.errorType});
}
