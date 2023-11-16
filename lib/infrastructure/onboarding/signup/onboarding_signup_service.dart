import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_signup_error_type.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingSignupService extends ApiService {
  OnboardingSignupService({super.user});

  Future<OnboardingSignupServiceResponse> createPerson({
    required OnboardingSignupAttributes signupAttributes,
    required String deviceToken,
    required String tsAndCsSignedAt,
  }) async {
    Map<String, dynamic> body = {
      'title': signupAttributes.title,
      'firstName': signupAttributes.firstName,
      'lastName': signupAttributes.lastName,
      'email': signupAttributes.email,
      'password': signupAttributes.password,
      'deviceToken': deviceToken,
      'tsAndCsSignedAt': tsAndCsSignedAt,
    };

    try {
      await post('/signup', body: body, authNeeded: false);

      return CreatePersonSuccesResponse();
    } catch (e) {
      if (e is HttpException && e.statusCode == 409) {
        return const CreatePersonErrorResponse(errorType: OnboardingSignupErrorType.emailAlreadyExists);
      }

      return const CreatePersonErrorResponse(errorType: OnboardingSignupErrorType.unknown);
    }
  }
}

abstract class OnboardingSignupServiceResponse extends Equatable {
  const OnboardingSignupServiceResponse();

  @override
  List<Object?> get props => [];
}

class CreatePersonSuccesResponse extends OnboardingSignupServiceResponse {}

class CreatePersonErrorResponse extends OnboardingSignupServiceResponse {
  final OnboardingSignupErrorType errorType;

  const CreatePersonErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
