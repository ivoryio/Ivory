import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_error_type.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingFinancialDetailsService extends ApiService {
  OnboardingFinancialDetailsService({super.user});

  Future<CreateTaxIdResponse> createTaxIdentification({
    required String taxId,
  }) async {
    const path = '/person/tax_identification';
    Map<String, dynamic> body = {
      'taxId': taxId,
      'country': 'DE',
      'primary': true,
    };

    try {
      await post(path, body: body);

      return CreateTaxIdSuccesResponse();
    } catch (e) {
      return const CreateTaxIdErrorResponse(errorType: FinancialDetailsErrorType.taxId);
    }
  }
}

abstract class CreateTaxIdResponse extends Equatable {
  const CreateTaxIdResponse();

  @override
  List<Object?> get props => [];
}

class CreateTaxIdSuccesResponse extends CreateTaxIdResponse {}

class CreateTaxIdErrorResponse extends CreateTaxIdResponse {
  final FinancialDetailsErrorType errorType;

  const CreateTaxIdErrorResponse({this.errorType = FinancialDetailsErrorType.taxId});

  @override
  List<Object?> get props => [errorType];
}
