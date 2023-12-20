import 'package:equatable/equatable.dart';

import '../../../models/transfer/credit_card_application.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_state.dart';

class OnboardingCardConfigurationPresenter {
  static OnboardingCardConfigurationViewModel presentCardConfiguration(
      {required OnboardingCardConfigurationState cardConfigurationState}) {
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
        isLoading: cardConfigurationState.isLoading,
      );
    } else if (cardConfigurationState is OnboardingCreditCardApplicationFetchedState) {
      return OnboardingCreditCardApplicationFetchedViewModel(
        cardApplication: cardConfigurationState.cardApplication,
        isLoading: cardConfigurationState.isLoading,
      );
    } else if (cardConfigurationState is OnboardingGetCreditCardApplicationLoadingState) {
      return OnboardingGetCreditCardApplicationLoadingViewModel();
    } else if (cardConfigurationState is OnboardingCreditCardApplicationUpdatedState) {
      return OnboardingCreditCardApplicationUpdatedViewModel(
        cardApplication: cardConfigurationState.cardApplication,
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
  final bool isLoading;

  WithCardInfoViewModel({
    required this.cardholderName,
    required this.maskedPAN,
    required this.expiryDate,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardholderName, maskedPAN, expiryDate, isLoading];
}

class OnboardingCreditCardApplicationFetchedViewModel extends OnboardingCardConfigurationViewModel {
  final CreditCardApplication cardApplication;
  final bool isLoading;

  OnboardingCreditCardApplicationFetchedViewModel({
    required this.cardApplication,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [cardApplication, isLoading];
}

class OnboardingGetCreditCardApplicationLoadingViewModel extends OnboardingCardConfigurationViewModel {}

class OnboardingCreditCardApplicationUpdatedViewModel extends OnboardingCardConfigurationViewModel {
  final CreditCardApplication cardApplication;

  OnboardingCreditCardApplicationUpdatedViewModel({
    required this.cardApplication,
  });

  @override
  List<Object?> get props => [cardApplication];
}
