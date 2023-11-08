import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';

class OnboardingPersonalDetailsState extends Equatable {
  final OnboardingPersonalDetailsAttributes attributes;
  final bool isLoading;
  final DateTime? tanRequestedAt;
  final bool? isAddressSaved;
  final bool? isMobileConfirmed;
  final OnboardingPersonalDetailsErrorType? errorType;

  const OnboardingPersonalDetailsState({
    this.attributes = const OnboardingPersonalDetailsAttributes(),
    this.isLoading = false,
    this.tanRequestedAt,
    this.isAddressSaved,
    this.isMobileConfirmed,
    this.errorType,
  });

  @override
  List<Object?> get props => [attributes, isLoading, tanRequestedAt, isAddressSaved, isMobileConfirmed];
}
