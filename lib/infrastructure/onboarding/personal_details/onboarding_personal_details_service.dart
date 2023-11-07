import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingPersonalDetailsService extends ApiService {
  OnboardingPersonalDetailsService({super.user});

  Future<OnboardingPersonalDetailsServiceResponse> createPerson({required User user}) async {
    this.user = user;

    try {
      return OnboardingCreatePersonSuccessResponse(personId: "personId");
    } catch (error) {
      return OnboardingPersonalDetailsServiceErrorResponse(errorType: OnboardingPersonalDetailsErrorType.unknown);
    }
  }
}

abstract class OnboardingPersonalDetailsServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCreatePersonSuccessResponse extends OnboardingPersonalDetailsServiceResponse {
  final String personId;

  OnboardingCreatePersonSuccessResponse({required this.personId});

  @override
  List<Object?> get props => [personId];
}

class OnboardingPersonalDetailsServiceErrorResponse extends OnboardingPersonalDetailsServiceResponse {
  final OnboardingPersonalDetailsErrorType errorType;

  OnboardingPersonalDetailsServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}
