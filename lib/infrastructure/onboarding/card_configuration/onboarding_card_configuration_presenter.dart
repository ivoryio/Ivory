import 'package:equatable/equatable.dart';

import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

class OnboardingCardConfigurationPresenter {
  static OnboardingCardConfigurationViewModel presentCardConfiguration({
    required OnboardingCardConfigurationState cardConfigurationState
  }) {
    if(cardConfigurationState is OnboardingCardConfigurationLoadingState) {
      return OnboardingCardConfigurationLoadingViewModel();
    } else if (cardConfigurationState is OnboardingCardConfigurationGenericErrorState) {
      return OnboardingCardConfigurationGenericErrorViewModel();
    } else if (cardConfigurationState is WithCardholderNameState) {
      return WithCardholderNameViewModel(cardholderName: cardConfigurationState.cardholderName);
    }

    return OnboardingCardConfigurationInitialViewModel();
  }
}

abstract class OnboardingCardConfigurationViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCardConfigurationInitialViewModel extends OnboardingCardConfigurationViewModel {}
class OnboardingCardConfigurationLoadingViewModel extends OnboardingCardConfigurationViewModel {}
class OnboardingCardConfigurationGenericErrorViewModel extends OnboardingCardConfigurationViewModel {}
class WithCardholderNameViewModel extends OnboardingCardConfigurationViewModel {
  final String cardholderName;

  WithCardholderNameViewModel({required this.cardholderName}) : super();

  @override
  List<Object?> get props => [cardholderName];
}