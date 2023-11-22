import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<CreateIdentificationResponse> createIdentification(
      {required User user,
      required String accountName,
      required String iban,
      required String termsAndCondsSignedAt}) async {
    return const CreateIdentificationSuccessResponse(urlForIntegration: 'https://url.com');
  }
}

class FakeFailingOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<CreateIdentificationResponse> createIdentification(
      {required User user,
      required String accountName,
      required String iban,
      required String termsAndCondsSignedAt}) async {
    return const CreateIdentificationErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
  }
}
