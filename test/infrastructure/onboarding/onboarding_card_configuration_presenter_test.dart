import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

void main() {
  const cardholderName = "Ivory TS";
  const maskedPAN = "493441******6055";
  const expiryDate = "09/26";
  final cardApplication = CreditCardApplication(
          id: '',
          accountIban: '',
          accountId: '',
          billingEndDate: DateTime.now(),
          billingStartDate: DateTime.now(),
          customerId: '',
          externalCustomerId: '',
          productType: '',
          status: '',
          referenceAccountId: '',
          approvedLimit: ApprovedLimit(
            currency: Currency.EUR,
            value: 0,
            unit: Unit.CENTS,
          ),
          createdAt: DateTime.now(),
          currentLimit: ApprovedLimit(
            currency: Currency.EUR,
            value: 0,
            unit: Unit.CENTS,
          ),
          declineReasons: [],
          defaultInterestAccountId: '',
          inDunning: false,
          interestStoringAccountId: '',
          latestRepaymentTypeSwitchDate: DateTime.now(),
          qesAt: DateTime.now(),
          repaymentOptions: RepaymentOptions(
            currentBillingCycle: '',
            currentType: '',
            gracePeriodInDays: 1,
            minimumAmount: ApprovedLimit(
              currency: Currency.EUR,
              value: 0,
              unit: Unit.CENTS,
            ),
            minimumAmountLowerThreshold: ApprovedLimit(
              currency: Currency.EUR,
              value: 0,
              unit: Unit.CENTS,
            ),
            minimumAmountUpperThreshold: ApprovedLimit(
              currency: Currency.EUR,
              value: 0,
              unit: Unit.CENTS,
            ),
            minimumPercentage: 0,
            minimumPercentageLowerThreshold: 0,
            minimumPercentageUpperThreshold: 0,
            upcomingBillingCycle: '',
            upcomingType: '',
          ),
          repaymentTypeSwitchAvailableDate: DateTime.now(),
          requestedLimit: ApprovedLimit(
            currency: Currency.EUR,
            value: 0,
            unit: Unit.CENTS,
          ),
          statementWithDetails: false,
        );

  test("When fetching cardholder name is successful should return a name", () {
    //given
    final onboardingCardConfigurationState = WithCardholderNameState(cardholderName: cardholderName);
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, WithCardholderNameViewModel(cardholderName: cardholderName, isLoading: false));
  });

  test("When any card configuration request fails should return an error", () {
    //given
    final onboardingCardConfigurationState = OnboardingCardConfigurationGenericErrorState();
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, OnboardingCardConfigurationGenericErrorViewModel());
  });

  test("When ordering card is in progress should return loading", () {
    //given
    final onboardingCardConfigurationState = WithCardholderNameState(cardholderName: cardholderName, isLoading: true);
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(viewModel, WithCardholderNameViewModel(cardholderName: cardholderName, isLoading: true));
  });

  test("When ordering card is successful should return success", () {
    //given
    final onboardingCardConfigurationState = OnboardingCardConfigurationGenericSuccessState();
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
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
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(
        viewModel,
        WithCardInfoViewModel(
          cardholderName: cardholderName,
          maskedPAN: maskedPAN,
          expiryDate: expiryDate,
        ));
  });

  test(
    "When fetching credit card application is succesful should return credit card application",
    () {
      //given
      final onboardingCardConfigurationState = OnboardingCreditCardApplicationFetchedState(
        cardApplication: cardApplication
      );
      //when
      final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
          cardConfigurationState: onboardingCardConfigurationState);
      //then
      expect(
          viewModel,
          OnboardingCreditCardApplicationFetchedViewModel(
              cardApplication: cardApplication));
    },
  );

  test("when updating credit card application is succesful should return updated credit card application", () {
    //given
    final onboardingCardConfigurationState = OnboardingCreditCardApplicationUpdatedState(
      cardApplication: cardApplication
    );
    //when
    final viewModel = OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: onboardingCardConfigurationState);
    //then
    expect(
        viewModel,
        OnboardingCreditCardApplicationUpdatedViewModel(
            cardApplication: cardApplication));
  });
}
