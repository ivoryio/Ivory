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
    } else if (cardConfigurationState is WithCardInfoState) {
     return WithCardInfoViewModel(
         cardholderName: cardConfigurationState.cardholderName,
         maskedPAN: cardConfigurationState.maskedPAN,
         expiryDate: cardConfigurationState.expiryDate,
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

class WithCardInfoViewModel extends OnboardingCardConfigurationViewModel {
  final String cardholderName;
  final String maskedPAN;
  final String expiryDate;

  WithCardInfoViewModel({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [cardholderName, maskedPAN, expiryDate];
}