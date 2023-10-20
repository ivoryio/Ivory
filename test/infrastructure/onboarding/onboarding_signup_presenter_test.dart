import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

void main() {
  test("When some information is missing it should return initial", () {
    //given
    final state = OnboardingSignupSubmittedState();

    //when
    final viewModel = OnboardingSignupPresenter.presentSignup(state: state);

    //then
    expect(viewModel, OnboardingSignupInitialViewModel());
  });

  test("When notifications are allowed", () {
    //given
    final state = OnboardingSignupSubmittedState(
      email: "email",
      firstName: "firstName",
      lastName: "lastName",
      notificationsAllowed: true,
      password: "password",
      title: "title",
    );

    //when
    final viewModel = OnboardingSignupPresenter.presentSignup(state: state);

    //then
    expect(viewModel, OnboardingSignupNotificationsAllowedViewModel());
  });

  test("When notifications are not allowed", () {
    //given
    final state = OnboardingSignupSubmittedState(
      email: "email",
      firstName: "firstName",
      lastName: "lastName",
      notificationsAllowed: false,
      password: "password",
      title: "title",
    );

    //when
    final viewModel = OnboardingSignupPresenter.presentSignup(state: state);

    //then
    expect(viewModel, OnboardingSignupNotificationsNotAllowedViewModel());
  });
}
