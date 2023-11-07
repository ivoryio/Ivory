import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_state.dart';

class OnboardingFinancialDetailsPresenter {
  static OnboardingFinancialDetailsViewModel present({required OnboardingFinancialDetailsState financialDetailsState}) {
    final taxId = financialDetailsState.taxId;

    return OnboardingFinancialDetailsViewModel(taxId: taxId);
  }
}

class OnboardingFinancialDetailsViewModel extends Equatable {
  final String taxId;

  const OnboardingFinancialDetailsViewModel({required this.taxId});

  @override
  List<Object?> get props => [taxId];
}
