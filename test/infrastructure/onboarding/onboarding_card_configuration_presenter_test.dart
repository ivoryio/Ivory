import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

void main(){
  const cardholderName = "Ivory TS";

  test("When fetching cardholder name is successful should return a name", () {
    //given
    final onboardingCardConfigurationState = WithCardholderNameState(cardholderName: cardholderName);
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, WithCardholderNameViewModel(cardholderName: cardholderName, isLoading: false));
  });

  test("When fetching cardholder name fails should return an error", () {
    //given
    final onboardingCardConfigurationState = OnboardingCardConfigurationGenericErrorState();
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, OnboardingCardConfigurationGenericErrorViewModel());
  });

  test("When ordering card is in progress should return loading", () {
    //given
    final onboardingCardConfigurationState = WithCardholderNameState(cardholderName: cardholderName, isLoading: true);
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, WithCardholderNameViewModel(cardholderName: cardholderName, isLoading: true));
  });

  test("When ordering card is successful should return success", () {
    //given
    final onboardingCardConfigurationState = OnboardingCardConfigurationGenericSuccessState();
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, OnboardingCardConfigurationGenericSuccessViewModel());
  });
}