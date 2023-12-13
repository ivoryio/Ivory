import 'package:solarisdemo/models/onboarding/onboarding_progress.dart';

class GetOnboardingProgressCommandAction {}

class FinalizeOnboardingCommandAction {}

class OnboardingProgressLoadingEventAction {}

class OnboardingFinalizedEventAction {}

class OnboardingProgressFetchedEvendAction {
  final OnboardingStep step;

  OnboardingProgressFetchedEvendAction({required this.step});
}

class OnboardingProgressFailedEventAction {}
