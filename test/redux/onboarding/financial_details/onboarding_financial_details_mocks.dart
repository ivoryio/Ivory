import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingFinancialDetailsService extends OnboardingFinancialDetailsService {
  @override
  Future<CreateTaxIdResponse> createTaxIdentification({required User user, required String taxId}) async {
    return CreateTaxIdSuccesResponse();
  }
}

class FakeFailingOnbordingFinancialDetailsService extends OnboardingFinancialDetailsService {
  @override
  Future<CreateTaxIdResponse> createTaxIdentification({required User user, required String taxId}) async {
    return const CreateTaxIdErrorResponse(
      errorType: FinancialDetailsErrorType.taxIdNotValid,
    );
  }
}