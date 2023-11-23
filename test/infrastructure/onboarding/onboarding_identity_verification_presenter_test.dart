import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_state.dart';

void main() {
  test('when screen is in default state should return initial viewModel', () {
    //given
    const OnboardingIdentityVerificationState onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
      urlForIntegration: '',
      isLoading: false,
    );
    //when
    final viewModel =
        OnboardingIdentityVerificationPresenter.present(identityVerificationState: onboardingIdentityVerificationState);
    //then
    expect(
      viewModel,
      const OnboardingIdentityVerificationViewModel(urlForIntegration: '', isLoading: false),
    );
  });

  test('when has correct iban, accountName and validation of term and condition should return viewModel', () {
    //given
    const OnboardingIdentityVerificationState onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
      urlForIntegration: 'https://url.com',
      isLoading: false,
    );
    //when
    final viewModel =
        OnboardingIdentityVerificationPresenter.present(identityVerificationState: onboardingIdentityVerificationState);
    //then
    expect(
      viewModel,
      const OnboardingIdentityVerificationViewModel(urlForIntegration: 'https://url.com', isLoading: false),
    );
  });

  test('when screen sent iban and accountName should return a loading viewModel', () {
    //given
    const OnboardingIdentityVerificationState onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
      urlForIntegration: '',
      isLoading: true,
    );
    //when
    final viewModel =
        OnboardingIdentityVerificationPresenter.present(identityVerificationState: onboardingIdentityVerificationState);
    //then
    expect(
      viewModel,
      const OnboardingIdentityVerificationViewModel(urlForIntegration: '', isLoading: true),
    );
  });

  test('when screen has incorrect data should return a error viewModel', () {
    //given
    const OnboardingIdentityVerificationState onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
      urlForIntegration: '',
      isLoading: false,
      errorType: OnboardingIdentityVerificationErrorType.invalidIban,
    );
    //when
    final viewModel =
        OnboardingIdentityVerificationPresenter.present(identityVerificationState: onboardingIdentityVerificationState);
    //then
    expect(
      viewModel,
      const OnboardingIdentityVerificationViewModel(
        urlForIntegration: '',
        isLoading: false,
        errorType: OnboardingIdentityVerificationErrorType.invalidIban,
      ),
    );
  });
}
