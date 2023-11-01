import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_state.dart';

void main() {
  test("When fetching is in initial loading it should return loading", () {
    //given
    final onboardingPersonalDetailsState = OnboardingPersonalDetailsInitialState();

    //when
    final viewModel = OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
      onboardingPersonalDetailsState: onboardingPersonalDetailsState,
    );

    //then
    expect(viewModel, OnboardingPersonalDetailsInitialViewModel());
  });

  test("When PersonalDetails caugths an error, should return error viewmodel", () {
    // given
    final onboardingPersonalDetailsState = OnboardingPersonalDetailsErrorState();

    // when
    final viewModel = OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
      onboardingPersonalDetailsState: onboardingPersonalDetailsState,
    );

    // then
    expect(viewModel, OnboardingPersonalDetailsErrorViewModel());
  });

  test("When address suggestion is requested and returns succesfully, vm should change accordingly", () {
    // given
    final suggestions = [
      AddressSuggestion(
        address: "address",
        city: "city",
        country: "country",
      ),
    ];
    final onboardingPersonalDetailsState = OnboardingPersonalDetailsAddressSuggestionsFetchedState(suggestions);

    // when
    final viewModel = OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
      onboardingPersonalDetailsState: onboardingPersonalDetailsState,
    );

    // then
    expect(
      viewModel,
      OnboardingPersonalDetailsFetchedViewModel(suggestions: suggestions),
    );
  });

  test("When address suggestion is selected, vm should change accordingly", () {
    // given
    final selectedSuggestion = AddressSuggestion(
      address: "address",
      city: "city",
      country: "country",
    );
    final onboardingPersonalDetailsState = OnboardingPersonalDetailsAddressSuggestionSelectedState(selectedSuggestion);

    // when
    final viewModel = OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
      onboardingPersonalDetailsState: onboardingPersonalDetailsState,
    );

    // then
    expect(
      viewModel,
      OnboardingPersonalDetailsAddressSuggestionSelectedViewModel(selectedSuggestion: selectedSuggestion),
    );
  });
}
