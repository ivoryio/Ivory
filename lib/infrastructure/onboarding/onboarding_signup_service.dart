import 'package:solarisdemo/services/api_service.dart';

class OnboardingSignupService extends ApiService {
  OnboardingSignupService({super.user});

  Future<OnboardingSignupServiceResponse> createPerson({
    required String title,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    String path = '/signup/person';
    Map<String, dynamic> body = {
      'title': title,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };

    try {
      await post(path, body: body);

      return CreatePersonSuccesResponse();
    } catch (e) {
      return CreatePersonErrorResponse();
    }
  }
}

abstract class OnboardingSignupServiceResponse {}

class CreatePersonSuccesResponse extends OnboardingSignupServiceResponse {}

class CreatePersonErrorResponse extends OnboardingSignupServiceResponse {}
