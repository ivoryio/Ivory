import 'package:equatable/equatable.dart';

import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

class OnboardingCardConfigurationPresenter {
  static OnboardingCardConfigurationViewModel presentCardConfiguration({
    required OnboardingCardConfigurationState cardConfigurationState
  }) {
   if (cardConfigurationState is OnboardingCardConfigurationGenericErrorState) {
      return OnboardingCardConfigurationGenericErrorViewModel();
    } else if (cardConfigurationState is OnboardingCardConfigurationGenericSuccessState) {
      return OnboardingCardConfigurationGenericSuccessViewModel();
    } else if (cardConfigurationState is WithCardholderNameState) {
      return WithCardholderNameViewModel(
          cardholderName: cardConfigurationState.cardholderName,
          isLoading: cardConfigurationState.isLoading,
      );
    }

    return OnboardingCardConfigurationInitialViewModel();
  }
}

abstract class OnboardingCardConfigurationViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCardConfigurationInitialViewModel extends OnboardingCardConfigurationViewModel {}
class OnboardingCardConfigurationGenericErrorViewModel extends OnboardingCardConfigurationViewModel {}
class OnboardingCardConfigurationGenericSuccessViewModel extends OnboardingCardConfigurationViewModel {}

class WithCardholderNameViewModel extends OnboardingCardConfigurationViewModel {
  final String cardholderName;
  final bool isLoading;

  WithCardholderNameViewModel({
    required this.cardholderName,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardholderName, isLoading];
}