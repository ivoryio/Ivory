import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_attributes.dart';

class OnboardingPersonalDetailsState extends Equatable {
  final OnboardingPersonalDetailsAttributes attributes;
  final bool isLoading;
  final DateTime? tanRequestedAt;
  final bool? isAddressSaved;
  final bool? isMobileConfirmed;

  const OnboardingPersonalDetailsState({
    this.attributes = const OnboardingPersonalDetailsAttributes(),
    this.isLoading = false,
    this.tanRequestedAt,
    this.isAddressSaved,
    this.isMobileConfirmed,
  });

  @override
  List<Object?> get props => [attributes, isLoading, tanRequestedAt, isAddressSaved, isMobileConfirmed];
}
