import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingFinancialDetailsService extends ApiService {
  OnboardingFinancialDetailsService({super.user});

  Future<OnboardingFinancialDetailsResponse> createTaxIdentification({
    // required User user,
    required String taxId,
  }) async {
    this.user = user;

    const path = '/person/tax_identification';
    Map<String, dynamic> body = {'taxId': taxId};

    try {
      await post(path, body: body);

      return CreateTaxIdentificationSuccessResponse();
    } catch (e) {
      return CreateTaxIdentificationErrorResponse();
    }
  }
}

abstract class OnboardingFinancialDetailsResponse extends Equatable {
  const OnboardingFinancialDetailsResponse();

  @override
  List<Object?> get props => [];
}

class CreateTaxIdentificationSuccessResponse extends OnboardingFinancialDetailsResponse {}

class CreateTaxIdentificationErrorResponse extends OnboardingFinancialDetailsResponse {}
