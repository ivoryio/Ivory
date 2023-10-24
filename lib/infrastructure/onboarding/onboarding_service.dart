import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_service_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingService extends ApiService {
  OnboardingService({super.user});

  Future<OnboardingServiceResponse> getOnboardingProgress({required User user}) async {
    if (this.user == null) {
      this.user = user;
    }
    try {
      final data = await get('onboarding/progress');
      final currentStep = data['currentStep'] as String;

      return OnboardingProgressSuccessResponse(currentStep: currentStep);
    } catch (error) {
      return OnboardingProgressErrorResponse();
    }
  }
}

abstract class OnboardingServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingProgressSuccessResponse extends OnboardingServiceResponse {
  final String currentStep;

  OnboardingProgressSuccessResponse({required this.currentStep});

  @override
  List<Object?> get props => [currentStep];
}

class OnboardingProgressErrorResponse extends OnboardingServiceResponse {
  final OnboardingServiceErrorType errorType;

  OnboardingProgressErrorResponse({this.errorType = OnboardingServiceErrorType.unknown});

  @override
  List<Object?> get props => [errorType];
}
