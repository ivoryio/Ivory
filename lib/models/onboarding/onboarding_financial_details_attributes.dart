import 'package:equatable/equatable.dart';

class OnboardingFinancialDetailsAttributes extends Equatable {
  final String? taxId;
  final OnboardingMaritalStatus? maritalStatus;
  final OnboardingLivingSituation? livingSituation;
  final int? numberOfDependents;
  final OnboardingOccupationalStatus? occupationalStatus;

  const OnboardingFinancialDetailsAttributes({
    this.taxId,
    this.maritalStatus,
    this.livingSituation,
    this.numberOfDependents,
    this.occupationalStatus,
  });

  OnboardingFinancialDetailsAttributes copyWith({
    String? taxId,
    OnboardingMaritalStatus? maritalStatus,
    OnboardingLivingSituation? livingSituation,
    int? numberOfDependents,
    OnboardingOccupationalStatus? occupationalStatus,
  }) {
    return OnboardingFinancialDetailsAttributes(
      taxId: taxId ?? this.taxId,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      livingSituation: livingSituation ?? this.livingSituation,
      numberOfDependents: numberOfDependents ?? this.numberOfDependents,
      occupationalStatus: occupationalStatus ?? this.occupationalStatus,
    );
  }

  @override
  List<Object?> get props => [taxId, maritalStatus, livingSituation, numberOfDependents, occupationalStatus];
}

enum OnboardingMaritalStatus { notMarried, married, divorced, widowed, preferNotToSay }

enum OnboardingLivingSituation { own, rent, parents }

enum OnboardingOccupationalStatus { employed, unemployed, freelancer, apprentice, retired, student }
