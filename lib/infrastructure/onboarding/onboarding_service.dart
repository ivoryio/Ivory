import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_persona_details_address_suggestions.dart';
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

      return OnboardingProgressSuccessResponse(step: currentStep);
    } catch (error) {
      return OnboardingProgressErrorResponse();
    }
  }

  Future<OnboardingServiceResponse> getAddressSuggestions({required User user, required String queryString}) async {
    this.user = user;

    try {
      final data = await get(
        'signup/address_suggestions',
        queryParameters: {
          "queryString": queryString,
        },
      );

      return OnboardingGetAddressSuggestionsSuccessResponse(
        suggestions: (data["suggestions"] as List).map((e) => AddressSuggestion.fromJson(e)).toList(),
      );
    } catch (error) {
      return OnboardingAddressSuggestionsErrorResponse();
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

class OnboardingGetAddressSuggestionsSuccessResponse extends OnboardingServiceResponse {
  final List<AddressSuggestion> suggestions;

  OnboardingGetAddressSuggestionsSuccessResponse({required this.suggestions});

  @override
  List<Object?> get props => [suggestions];
}

class OnboardingAddressSuggestionsErrorResponse extends OnboardingServiceResponse {
  final OnboardingServiceErrorType errorType;

  OnboardingAddressSuggestionsErrorResponse({this.errorType = OnboardingServiceErrorType.cantGetAddressSuggestions});

  @override
  List<Object?> get props => [errorType];
}
