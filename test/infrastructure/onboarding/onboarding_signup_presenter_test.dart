import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/models/auth/auth_type.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

import '../bank_card/bank_card_presenter_test.dart';

void main() {
  const signupAttributes = OnboardingSignupAttributes(
    email: "email",
    firstName: "firstName",
    lastName: "lastName",
    notificationsAllowed: true,
    password: "password",
    title: "title",
  );

  test("When signing up and authState is null, the signup attributes should match the state", () {
    //given
    const signupState = OnboardingSignupState(
      signupAttributes: signupAttributes,
    );

    //when
    final viewModel = OnboardingSignupPresenter.present(signupState: signupState);

    //then
    expect(viewModel, const OnboardingSignupViewModel(signupAttributes: signupAttributes));
  });

  test("When both auth and signup are loading, isLoading should be true", () {
    //given
    final authState = AuthLoadingState();
    const signupState = OnboardingSignupState(
      signupAttributes: signupAttributes,
      isLoading: true,
    );

    //when
    final viewModel = OnboardingSignupPresenter.present(signupState: signupState, authState: authState);

    //then
    expect(viewModel, const OnboardingSignupViewModel(signupAttributes: signupAttributes, isLoading: true));
  });

  test("When auth is loading and signup is not, isLoading should be true", () {
    //given
    final authState = AuthLoadingState();
    const signupState = OnboardingSignupState(
      signupAttributes: signupAttributes,
    );

    //when
    final viewModel = OnboardingSignupPresenter.present(signupState: signupState, authState: authState);

    //then
    expect(viewModel, const OnboardingSignupViewModel(signupAttributes: signupAttributes, isLoading: true));
  });

  test("When signup is loading and auth is not, isLoading should be true", () {
    //given
    final authState = AuthenticationInitializedState(MockUser(), AuthType.onboarding);
    const signupState = OnboardingSignupState(
      signupAttributes: signupAttributes,
      isLoading: true,
    );

    //when
    final viewModel = OnboardingSignupPresenter.present(signupState: signupState, authState: authState);

    //then
    expect(viewModel, const OnboardingSignupViewModel(signupAttributes: signupAttributes, isLoading: true));
  });

  test("When both auth is initialized and signup is successful, isSuccessful should be true", () {
    // given
    final authState = AuthenticationInitializedState(MockUser(), AuthType.onboarding);
    const signupState = OnboardingSignupState(
      signupAttributes: signupAttributes,
      isSuccessful: true,
    );

    // when
    final viewModel = OnboardingSignupPresenter.present(signupState: signupState, authState: authState);

    // then
    expect(
      viewModel,
      const OnboardingSignupViewModel(signupAttributes: signupAttributes, isLoading: false, isSuccessful: true),
    );
  });
}
