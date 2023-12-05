import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

void main(){
  const cardholderName = "Ivory TS";
  const maskedPAN = "493441******6055";
  const expiryDate = "09/26";

  test("When fetching cardholder name is successful should return a name", () {
    //given
    final onboardingCardConfigurationState = WithCardholderNameState(cardholderName: cardholderName);
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, WithCardholderNameViewModel(cardholderName: cardholderName, isLoading: false));
  });

  test("When any card configuration request fails should return an error", () {
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

  test("When fetching card details is successful should return card details data", () {
    //given
    final onboardingCardConfigurationState = WithCardInfoState(
        cardholderName: cardholderName,
        maskedPAN: maskedPAN,
        expiryDate: expiryDate,
    );
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel,WithCardInfoViewModel(
        cardholderName: cardholderName,
        maskedPAN: maskedPAN,
        expiryDate: expiryDate,
    ));
  });
}