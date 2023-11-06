import 'package:equatable/equatable.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingFinancialDetailsService extends ApiService {
  OnboardingFinancialDetailsService({super.user});

  Future<OnboardingFinancialDetailsResponse> createTaxIdentification({required String taxId}) async {
    return CreateTaxIdentificationSuccessResponse();
  }
}

abstract class OnboardingFinancialDetailsResponse extends Equatable {
  const OnboardingFinancialDetailsResponse();

  @override
  List<Object?> get props => [];
}

class CreateTaxIdentificationSuccessResponse extends OnboardingFinancialDetailsResponse {}
