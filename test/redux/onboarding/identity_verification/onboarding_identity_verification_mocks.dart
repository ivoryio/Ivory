import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identification_status.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<IdentityVerificationServiceResponse> createIdentification({
    required User user,
    required String accountName,
    required String iban,
    required String termsAndCondsSignedAt,
  }) async {
    return const CreateIdentificationSuccessResponse(urlForIntegration: 'https://url.com');
  }

  @override
  Future<IdentityVerificationServiceResponse> getSignupIdentificationInfo({
    required User user,
  }) async {
    return const GetSignupIdentificationInfoSuccessResponse(
      identificationStatus: OnboardingIdentificationStatus.authorizationRequired,
      documents: [
        Document(
          id: 'documentId1',
          fileSize: 1024,
          fileType: 'PDF',
          documentType: DocumentType.creditCardContract,
        ),
        Document(
          id: 'documentId2',
          fileSize: 2048,
          fileType: 'PDF',
          documentType: DocumentType.creditCardContract,
        )
      ],
    );
  }

  @override
  Future<IdentityVerificationServiceResponse> authorizeIdentification({required User user}) async {
    return AuthorizeIdentificationSuccessResponse();
  }
}

class FakeFailingOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<IdentityVerificationServiceResponse> createIdentification({
    required User user,
    required String accountName,
    required String iban,
    required String termsAndCondsSignedAt,
  }) async {
    return const CreateIdentificationErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
  }

  @override
  Future<IdentityVerificationServiceResponse> getSignupIdentificationInfo({
    required User user,
  }) async {
    return const GetSignupIdentificationInfoErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
  }

  @override
  Future<IdentityVerificationServiceResponse> authorizeIdentification({required User user}) async {
    return const AuthorizeIdentificationErrorResponse(
      errorType: OnboardingIdentityVerificationErrorType.unknown,
    );
  }
}
