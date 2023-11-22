import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<CreateUrlForIntegrationResponse> createIdentification(
      {required User user,
      required String accountName,
      required String iban,
      required String termsAndCondsSignedAt}) async {
    return const CreateUrlForIntegrationSuccesResponse(urlForIntegration: 'https://url.com');
  }
}

class FakeFailingOnbordingIdentityVerificationService extends OnbordingIdentityVerificationService {
  @override
  Future<CreateUrlForIntegrationResponse> createIdentification(
      {required User user,
      required String accountName,
      required String iban,
      required String termsAndCondsSignedAt}) async {
    return const CreateUrlForIntegrationErrorResponse(errorType: OnboardingIdentityVerificationErrorType.unknown);
  }
}
