import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnbordingIdentityVerificationService extends ApiService {
  OnbordingIdentityVerificationService({super.user});

  Future<CreateReferenceAccountIbanResponse> createIdentification({
    required User user,
    required String iban,
    required String termsAndCondsSignedAt,
  }) async {
    this.user = user;

    const path = '/signup/identification';
    Map<String, dynamic> body = {
      'iban': iban,
      'terms_and_conditions_signed_at': termsAndCondsSignedAt,
    };

    try {
      final response = await post(path, body: body);

      return CreateReferenceAccountIbanSuccesResponse(urlForIntegration: response['url']);
    } catch (err) {
      return const CreateReferenceAccountIbanErrorResponse(
          errorType: OnboardingIdentityVerificationErrorType.invalidIban);
    }
  }
}

abstract class CreateReferenceAccountIbanResponse extends Equatable {
  const CreateReferenceAccountIbanResponse();

  @override
  List<Object?> get props => [];
}

class CreateReferenceAccountIbanSuccesResponse extends CreateReferenceAccountIbanResponse {
  final String urlForIntegration;

  const CreateReferenceAccountIbanSuccesResponse({required this.urlForIntegration});

  @override
  List<Object?> get props => [urlForIntegration];
}

class CreateReferenceAccountIbanErrorResponse extends CreateReferenceAccountIbanResponse {
  final OnboardingIdentityVerificationErrorType errorType;

  const CreateReferenceAccountIbanErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
