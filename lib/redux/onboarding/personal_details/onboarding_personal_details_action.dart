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

class CreatePersonAccountCommandAction {
  final String houseNumber;
  final String addressLine;

  CreatePersonAccountCommandAction({
    required this.houseNumber,
    required this.addressLine,
  });
}

class OnboardingPersonalDetailsLoadingEventAction {}

class CreatePersonAccountSuccessEventAction {
  final String personId;

  CreatePersonAccountSuccessEventAction({required this.personId});
}

class CreatePersonAccountFailedEventAction {
  final OnboardingPersonalDetailsErrorType errorType;

  CreatePersonAccountFailedEventAction({required this.errorType});
}
