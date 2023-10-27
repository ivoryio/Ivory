import 'dart:developer';

import 'package:solarisdemo/services/api_service.dart';

class OnboardingSignupService extends ApiService {
  OnboardingSignupService({super.user});

  Future<OnboardingSignupServiceResponse> createPerson({
    required String title,
    required String email,
    required String firstName,
    required String lastName,
    required bool pushNotificationsAllowed,
    required String tsAndCsSignedAt,
  }) async {
    String path = '/signup';
    Map<String, dynamic> body = {
      'title': title,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'tsAndCsSignedAt': tsAndCsSignedAt,
    };

    try {
      await post(path, body: body, authNeeded: false);

      return CreatePersonSuccesResponse();
    } catch (e) {
      return CreatePersonErrorResponse();
    }
  }
}

abstract class OnboardingSignupServiceResponse {}

class CreatePersonSuccesResponse extends OnboardingSignupServiceResponse {}

class CreatePersonErrorResponse extends OnboardingSignupServiceResponse {}
