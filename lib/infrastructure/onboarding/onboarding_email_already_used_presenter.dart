import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_state.dart';

class OnboardingEmailAlreadyUsedPresenter {
  static OnboardingEmailAlreadyUsedViewModel presentEmail({required OnboardingSignupState state}) {
    if (state is OnboardingSignupSubmittedState) {
      if (state.password != null) {
        OnboardingEmailAlreadyUsedUpdatedViewModel(password: state.password!);
      }

      return OnboardingEmailAlreadyUsedInitialViewModel();
    }

    return OnboardingEmailAlreadyUsedInitialViewModel();
  }
}

abstract class OnboardingEmailAlreadyUsedViewModel extends Equatable {
  final String? password;

  const OnboardingEmailAlreadyUsedViewModel({this.password});

  @override
  List<Object?> get props => [];
}

class OnboardingEmailAlreadyUsedInitialViewModel extends OnboardingEmailAlreadyUsedViewModel {}

class OnboardingEmailAlreadyUsedUpdatedViewModel extends OnboardingEmailAlreadyUsedViewModel {
  final String password;

  const OnboardingEmailAlreadyUsedUpdatedViewModel({required this.password}) : super(password: password);
}
