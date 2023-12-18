import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';
import 'package:solarisdemo/models/onboarding/onboarding_service_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingService extends ApiService {
  OnboardingService({super.user});

  Future<OnboardingServiceResponse> getOnboardingProgress({required User user}) async {
    this.user = user;

    try {
      final data = await get('signup/progress');
      final currentStep = OnboardingStepExtension.fromString(data['currentStep']);

      return OnboardingProgressSuccessResponse(
        step: currentStep,
        mobileNumber: data['mobileNumber'] ?? '',
        creditCardApplicationId: data['creditCardApplicationId'] ?? '',
      );
    } catch (error) {
      return OnboardingProgressErrorResponse();
    }
  }

  Future<OnboardingServiceResponse> finalizeOnboarding({required User user}) async {
    this.user = user;

    try {
      await patch('signup/finalize');
      return OnboardingFinalizeSuccessResponse();
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
  final String mobileNumber;
  final String creditCardApplicationId;

  OnboardingProgressSuccessResponse({
    required this.step,
    required this.mobileNumber,
    this.creditCardApplicationId = '',
  });

  @override
  List<Object?> get props => [step, mobileNumber, creditCardApplicationId];
}

class OnboardingFinalizeSuccessResponse extends OnboardingServiceResponse {}

class OnboardingProgressErrorResponse extends OnboardingServiceResponse {
  final OnboardingServiceErrorType errorType;

  OnboardingProgressErrorResponse({this.errorType = OnboardingServiceErrorType.unknown});

  @override
  List<Object?> get props => [errorType];
}
