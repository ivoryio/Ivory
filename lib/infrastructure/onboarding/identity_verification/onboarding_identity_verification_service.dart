import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnbordingIdentityVerificationService extends ApiService {
  OnbordingIdentityVerificationService({super.user});

  Future<IdentityVerificationServiceResponse> createIdentification({
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

  Future<IdentityVerificationServiceResponse> getSignupIdentificationInfo({
    required User user,
  }) async {
    this.user = user;

    try {
      final response = await get('/signup/identification');

      return GetSignupIdentificationInfoSuccessResponse(
        identificationStatus: _parseIdentificationStatus(response['status'] ?? ""),
        documents: (response['documents'] as List)
            .map(
              (document) => Document(
                id: document['id'],
                documentType: DocumentTypeParser.parse(document['document_type']),
                fileType: document['content_type'],
                fileSize: document['size'] ?? 0,
              ),
            )
            .toList(),
      );
    } catch (err) {
      return const GetSignupIdentificationInfoErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
    }
  }
}

OnboardingIdentificationStatus _parseIdentificationStatus(String status) {
  switch (status) {
    case 'authorization_required':
      return OnboardingIdentificationStatus.authorizationRequired;
    case 'failed':
      return OnboardingIdentificationStatus.failed;
    default:
      return OnboardingIdentificationStatus.unknown;
  }
}

abstract class IdentityVerificationServiceResponse extends Equatable {
  const IdentityVerificationServiceResponse();

  @override
  List<Object?> get props => [];
}

class CreateIdentificationSuccessResponse extends IdentityVerificationServiceResponse {
  final String urlForIntegration;

  const CreateIdentificationSuccessResponse({required this.urlForIntegration});

  @override
  List<Object?> get props => [urlForIntegration];
}

class CreateIdentificationErrorResponse extends IdentityVerificationServiceResponse {
  final OnboardingIdentityVerificationErrorType errorType;

  const CreateIdentificationErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

class GetSignupIdentificationInfoSuccessResponse extends IdentityVerificationServiceResponse {
  final OnboardingIdentificationStatus identificationStatus;
  final List<Document> documents;

  const GetSignupIdentificationInfoSuccessResponse({required this.identificationStatus, required this.documents});

  @override
  List<Object?> get props => [identificationStatus, documents];
}

class GetSignupIdentificationInfoErrorResponse extends IdentityVerificationServiceResponse {
  final OnboardingIdentityVerificationErrorType errorType;

  const GetSignupIdentificationInfoErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
