import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

void main() {
  const attributes = OnboardingPersonalDetailsAttributes(
    birthDate: "01/01/2000",
    city: "Berlin",
    country: "DE",
    nationality: "DE",
    selectedAddress: AddressSuggestion(address: "Berlin Strasse", city: "Berlin", country: "DE"),
  );

  test("When OnboardingPersonalDetailsState have data, it should return the correct OnboardingPersonalDetailsViewModel",
      () {
    // given
    final currentDate = DateTime.now();
    final state = OnboardingPersonalDetailsState(
      attributes: attributes,
      isLoading: false,
      isAddressSaved: true,
      isMobileConfirmed: true,
      tanRequestedAt: currentDate,
      errorType: OnboardingPersonalDetailsErrorType.unknown,
    );

    // when
    final viewModel = OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
      onboardingPersonalDetailsState: state,
    );

    // then
    expect(
      viewModel,
      OnboardingPersonalDetailsViewModel(
        attributes: attributes,
        isLoading: false,
        isAddressSaved: true,
        isMobileConfirmed: true,
        tanRequestedAt: currentDate,
        errorType: OnboardingPersonalDetailsErrorType.unknown,
      ),
    );
  });
}
