import 'package:equatable/equatable.dart';

class OnboardingFinancialDetailsAttributes extends Equatable {
  final String? taxId;
  final OnboardingMaritalStatus? maritalStatus;
  final OnboardingLivingSituation? livingSituation;
  final int? numberOfDependents;
  final OnboardingOccupationalStatus? occupationalStatus;
  final String dateOfEmployment;

  const OnboardingFinancialDetailsAttributes({
    this.taxId,
    this.maritalStatus,
    this.livingSituation,
    this.numberOfDependents,
    this.occupationalStatus,
    this.dateOfEmployment = '',
  });

  OnboardingFinancialDetailsAttributes copyWith({
    String? taxId,
    OnboardingMaritalStatus? maritalStatus,
    OnboardingLivingSituation? livingSituation,
    int? numberOfDependents,
    OnboardingOccupationalStatus? occupationalStatus,
    String? dateOfEmployment,
  }) {
    return OnboardingFinancialDetailsAttributes(
      taxId: taxId ?? this.taxId,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      livingSituation: livingSituation ?? this.livingSituation,
      numberOfDependents: numberOfDependents ?? this.numberOfDependents,
      occupationalStatus: occupationalStatus ?? this.occupationalStatus,
      dateOfEmployment: dateOfEmployment ?? this.dateOfEmployment,
    );
  }

  @override
  List<Object?> get props => [taxId, maritalStatus, livingSituation, numberOfDependents, occupationalStatus];
}

enum OnboardingMaritalStatus { notMarried, married, divorced, widowed, preferNotToSay }

enum OnboardingLivingSituation { own, rent, parents }

enum OnboardingOccupationalStatus { employed, unemployed, apprentice, retired, student }
