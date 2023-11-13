import 'package:solarisdemo/models/mobile_number/mobile_number_error_type.dart';
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


class CreateMobileNumberCommandAction {
  final String mobileNumber;

  CreateMobileNumberCommandAction({required this.mobileNumber});
}

class VerifyMobileNumberCommandAction {
  final String mobileNumber;

  VerifyMobileNumberCommandAction({
    required this.mobileNumber,
  });
}

class ConfirmMobileNumberCommandAction {
  final String mobileNumber;
  final String token;

  ConfirmMobileNumberCommandAction({required this.mobileNumber, required this.token});
}

class MobileNumberCreatedEventAction {
  final String mobileNumber;
  MobileNumberCreatedEventAction({required this.mobileNumber});
}

class MobileNumberVerifiedEventAction {}

class MobileNumberConfirmedEventAction {}

class MobileNumberCreateFailedEventAction {
  final MobileNumberErrorType errorType;

  MobileNumberCreateFailedEventAction({required this.errorType});
}

class MobileNumberConfirmationFailedEventAction {
  final MobileNumberErrorType errorType;

  MobileNumberConfirmationFailedEventAction({required this.errorType});
}

class MobileNumberVerificationFailedEventAction {
  final MobileNumberErrorType errorType;

  MobileNumberVerificationFailedEventAction({required this.errorType});
}
