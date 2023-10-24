import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
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
      final currentStep = OnboardingStepExtension.fromString(data['currentStep']);

      return OnboardingProgressSuccessResponse(step: currentStep);
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
  final OnboardingStep step;

  OnboardingProgressSuccessResponse({required this.step});

  @override
  List<Object?> get props => [step];
}

class OnboardingProgressErrorResponse extends OnboardingServiceResponse {
  final OnboardingServiceErrorType errorType;

  OnboardingProgressErrorResponse({this.errorType = OnboardingServiceErrorType.unknown});

  @override
  List<Object?> get props => [errorType];
}
