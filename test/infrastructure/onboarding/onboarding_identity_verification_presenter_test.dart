import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
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

  test("When is authorized, the view model should contain isAuthorized = true", () {
    // given
    const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
      urlForIntegration: 'https://url.com',
      isLoading: false,
      isAuthorized: true,
    );

    // when
    final viewModel =
        OnboardingIdentityVerificationPresenter.present(identityVerificationState: onboardingIdentityVerificationState);

    // then
    expect(
      viewModel,
      const OnboardingIdentityVerificationViewModel(
        urlForIntegration: 'https://url.com',
        isLoading: false,
        isAuthorized: true,
      ),
    );
  });

  group('sign with TAN', () {
    test('when screen sent TAN should return a loading viewModel', () {
      //given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: true,
        isTanConfirmed: true,
      );
      //when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: onboardingIdentityVerificationState);
      //then
      expect(
          viewModel,
          const OnboardingIdentityVerificationViewModel(
            isLoading: true,
            isTanConfirmed: true,
          ));
    });

    test('when screen sent incorrect TAN should return a error viewModel', () {
      //given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
        errorType: OnboardingIdentityVerificationErrorType.unknown,
      );
      //when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: onboardingIdentityVerificationState);
      //then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          errorType: OnboardingIdentityVerificationErrorType.unknown,
        ),
      );
    });

    test('when screen sent correct TAN should return viewModel', () {
      //given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
        isTanConfirmed: true,
      );
      //when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: onboardingIdentityVerificationState);
      //then
      expect(
          viewModel,
          const OnboardingIdentityVerificationViewModel(
            isLoading: false,
            isTanConfirmed: true,
          ));
    });

    test("When notificationsState is null, the view model should contain isScoringSuccessful = null", () {
      // given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
      );

      // when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: onboardingIdentityVerificationState,
        notificationState: null,
      );

      // then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          isScoringSuccessful: null,
        ),
      );
    });

    test(
        "When notificationsState is NotificationScoringSuccessfulState, the view model should contain isScoringSuccessful = true",
        () {
      // given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
      );

      // when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: onboardingIdentityVerificationState,
        notificationState: NotificationScoringSuccessfulState(),
      );

      // then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          isScoringSuccessful: true,
        ),
      );
    });

    test(
        "When notificationsState is NotificationScoringFailedState, the view model should contain isScoringSuccessful = false",
        () {
      // given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
      );

      // when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: onboardingIdentityVerificationState,
        notificationState: NotificationScoringFailedState(),
      );

      // then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          isScoringSuccessful: false,
        ),
      );
    });
  });

  group('credit limit congratulations screen', () {
    test('when fetching credit limit, should return to viewModel', () {
      //given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
        creditLimit: 1000,
      );
      //when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: onboardingIdentityVerificationState);
      //then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          creditLimit: 1000,
        ),
      );
    });

    test("when state isIdentificationSuccessful is not null, should return to viewModel", () {
      // given
      const onboardingIdentityVerificationState = OnboardingIdentityVerificationState(
        isLoading: false,
        isIdentificationSuccessful: true,
      );

      // when
      final viewModel = OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: onboardingIdentityVerificationState,
      );

      // then
      expect(
        viewModel,
        const OnboardingIdentityVerificationViewModel(
          isLoading: false,
          isIdentificationSuccessful: true,
        ),
      );
    });
  });
}
