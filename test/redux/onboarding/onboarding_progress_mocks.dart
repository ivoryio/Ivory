import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/auth/auth_service.dart';
import 'package:solarisdemo/infrastructure/device/device_service.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_service.dart';
import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';

import '../auth/auth_mocks.dart';

class MockPerson extends Mock implements Person {}

class MockPersonAccount extends Mock implements PersonAccount {}

class FakeOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(step: OnboardingStep.signedUp, mobileNumber: '');
  }

  @override
  Future<OnboardingServiceResponse> finalizeOnboarding({User? user}) async {
    return OnboardingFinalizeSuccessResponse();
  }
}

class FakeFailingOnboardingService extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressErrorResponse();
  }

  @override
  Future<OnboardingServiceResponse> finalizeOnboarding({User? user}) async {
    return OnboardingProgressErrorResponse();
  }
}

class FakeOnboardingServiceWithMobileNumber extends OnboardingService {
  @override
  Future<OnboardingServiceResponse> getOnboardingProgress({User? user}) async {
    return OnboardingProgressSuccessResponse(step: OnboardingStep.phoneNumberVerified, mobileNumber: '123456');
  }
}

class FakeDeviceService extends DeviceService {
  @override
  Future<CacheCredentials?> getCredentialsFromCache() async {
    return CacheCredentials(email: 'email@example.com', password: 'password', deviceId: null);
  }
}

class FakeAuthService extends AuthService {
  @override
  Future<AuthServiceResponse> login(String username, String passcode) async {
    return LoginSuccessResponse(user: MockUser());
  }
}

class FakePersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getPerson({User? user}) async {
    return GetPersonSuccessResponse(person: MockPerson());
  }

  @override
  Future<PersonServiceResponse> getPersonAccount({required User user}) async {
    return GetPersonAccountSuccessResponse(personAccount: MockPersonAccount());
  }
}
