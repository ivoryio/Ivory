import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnbordingIdentityVerificationService extends ApiService {
  OnbordingIdentityVerificationService({super.user});

  Future<CreateIdentificationResponse> createIdentification({
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

      return CreateIdentificationSuccessResponse(urlForIntegration: response['url']);
    } catch (err) {
      return const CreateIdentificationErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
    }
  }
}

abstract class CreateIdentificationResponse extends Equatable {
  const CreateIdentificationResponse();

  @override
  List<Object?> get props => [];
}

class CreateIdentificationSuccessResponse extends CreateIdentificationResponse {
  final String urlForIntegration;

  const CreateIdentificationSuccessResponse({required this.urlForIntegration});

  @override
  List<Object?> get props => [urlForIntegration];
}

class CreateIdentificationErrorResponse extends CreateIdentificationResponse {
  final OnboardingIdentityVerificationErrorType errorType;

  const CreateIdentificationErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
