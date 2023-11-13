import 'package:equatable/equatable.dart';

class OnboardingFinancialDetailsAttributes extends Equatable {
  final String? taxId;
  final OnboardingMaritalStatus? maritalStatus;
  final OnboardingLivingSituation? livingSituation;
  final int? numberOfDependents;

  const OnboardingFinancialDetailsAttributes({
    this.taxId,
    this.maritalStatus,
    this.livingSituation,
    this.numberOfDependents,
  });

  OnboardingFinancialDetailsAttributes copyWith({
    String? taxId,
    OnboardingMaritalStatus? maritalStatus,
    OnboardingLivingSituation? livingSituation,
    int? numberOfDependents,
  }) {
    return OnboardingFinancialDetailsAttributes(
      taxId: taxId ?? this.taxId,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      livingSituation: livingSituation ?? this.livingSituation,
      numberOfDependents: numberOfDependents ?? this.numberOfDependents,
    );
  }

  @override
  List<Object?> get props => [taxId, maritalStatus, livingSituation, numberOfDependents];
}

enum OnboardingMaritalStatus { notMarried, married, divorced, widowed, preferNotToSay }

enum OnboardingLivingSituation { own, rent, parents }
