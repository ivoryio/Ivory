import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnbordingIdentityVerificationService extends ApiService {
  OnbordingIdentityVerificationService({super.user});

  Future<CreateUrlForIntegrationResponse> createIdentification({
    required User user,
    required String accountName,
    required String iban,
    required String termsAndCondsSignedAt,
  }) async {
    this.user = user;

    const path = '/signup/identification';
    Map<String, dynamic> body = {
      'accountName': accountName,
      'iban': iban,
      'terms_and_conditions_signed_at': termsAndCondsSignedAt,
    };

    try {
      final response = await post(path, body: body);

      return CreateUrlForIntegrationSuccesResponse(urlForIntegration: response['url']);
    } catch (err) {
      return const CreateUrlForIntegrationErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
    }
  }
}

abstract class CreateUrlForIntegrationResponse extends Equatable {
  const CreateUrlForIntegrationResponse();

  @override
  List<Object?> get props => [];
}

class CreateUrlForIntegrationSuccesResponse extends CreateUrlForIntegrationResponse {
  final String urlForIntegration;

  const CreateUrlForIntegrationSuccesResponse({required this.urlForIntegration});

  @override
  List<Object?> get props => [urlForIntegration];
}

class CreateUrlForIntegrationErrorResponse extends CreateUrlForIntegrationResponse {
  final OnboardingIdentityVerificationErrorType errorType;

  const CreateUrlForIntegrationErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
