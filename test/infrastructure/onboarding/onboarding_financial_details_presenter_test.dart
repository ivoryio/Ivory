import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

void main() {
  test('when screen is in default state should return initial viewModel', () {
    //given
    const OnboardingFinancialDetailsState onboardingFinancialDetailsState = OnboardingFinancialDetailsState(
      financialDetailsAttributes: OnboardingFinancialDetailsAttributes(
        taxId: '',
      ),
      isLoading: false,
    );
    //when
    final viewModel = OnboardingFinancialDetailsPresenter.present(financialState: onboardingFinancialDetailsState);
    //then
    expect(
      viewModel,
      const OnboardingFinancialDetailsViewModel(
          financialDetailsAttributes: OnboardingFinancialDetailsAttributes(taxId: ''), isLoading: false),
    );
  });

  test('when screen has correct taxId number should return viewModel', () {
    //given
    const OnboardingFinancialDetailsState onboardingFinancialDetailsState = OnboardingFinancialDetailsState(
      financialDetailsAttributes: OnboardingFinancialDetailsAttributes(
        taxId: '48954371207',
      ),
      isLoading: false,
    );
    //when
    final viewModel = OnboardingFinancialDetailsPresenter.present(financialState: onboardingFinancialDetailsState);
    //then
    expect(
      viewModel,
      const OnboardingFinancialDetailsViewModel(
          financialDetailsAttributes: OnboardingFinancialDetailsAttributes(taxId: '48954371207'), isLoading: false),
    );
  });

  test('when screen sent the taxId number should return a loading viewModel', () {
    //given
    const OnboardingFinancialDetailsState onboardingFinancialDetailsState = OnboardingFinancialDetailsState(
      financialDetailsAttributes: OnboardingFinancialDetailsAttributes(),
      isLoading: true,
    );
    //when
    final viewModel = OnboardingFinancialDetailsPresenter.present(financialState: onboardingFinancialDetailsState);
    //then
    expect(
      viewModel,
      const OnboardingFinancialDetailsViewModel(
          financialDetailsAttributes: OnboardingFinancialDetailsAttributes(), isLoading: true),
    );
  });

  test('when screen has incorrect taxId number should retun a error viewModel', () {
    //given
    const OnboardingFinancialDetailsState onboardingFinancialDetailsState = OnboardingFinancialDetailsState(
      financialDetailsAttributes: OnboardingFinancialDetailsAttributes(
        taxId: '123',
      ),
      isLoading: false,
      errorType: FinancialDetailsErrorType.taxIdNotValid,
    );
    //when
    final viewModel = OnboardingFinancialDetailsPresenter.present(financialState: onboardingFinancialDetailsState);
    //then
    expect(
      viewModel,
      const OnboardingFinancialDetailsViewModel(
          financialDetailsAttributes: OnboardingFinancialDetailsAttributes(taxId: '123'),
          isLoading: false,
          errorType: FinancialDetailsErrorType.taxIdNotValid),
    );
  });
}
