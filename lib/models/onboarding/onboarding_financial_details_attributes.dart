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
  List<Object?> get props =>
      [taxId, maritalStatus, livingSituation, numberOfDependents, occupationalStatus, dateOfEmployment];
}

enum OnboardingMaritalStatus { notMarried, married, divorced, widowed, preferNotToSay }

enum OnboardingLivingSituation { own, rent, parents }

enum OnboardingOccupationalStatus { employed, unemployed, apprentice, retired, student }

String getOnboardingMaritalStatusValue(OnboardingMaritalStatus maritalStatus) {
  switch (maritalStatus) {
    case OnboardingMaritalStatus.notMarried:
      return 'SINGLE';
    case OnboardingMaritalStatus.married:
      return 'MARRIED';
    case OnboardingMaritalStatus.divorced:
      return 'DIVORCED';
    case OnboardingMaritalStatus.widowed:
      return 'WIDOWED';
    case OnboardingMaritalStatus.preferNotToSay:
      return 'UNKNOWN';
  }
}

String getOnboardingLivingSituationValue(OnboardingLivingSituation livingSituation) {
  switch (livingSituation) {
    case OnboardingLivingSituation.own:
      return 'LIVING_IN_OWN_HOUSE';
    case OnboardingLivingSituation.rent:
      return 'LIVING_IN_RENTED_HOUSE';
    case OnboardingLivingSituation.parents:
      return 'LIVING_WITH_PARENTS';
  }
}

String getOnboardingOccupationalStatusValue(OnboardingOccupationalStatus occupationalStatus) {
  switch (occupationalStatus) {
    case OnboardingOccupationalStatus.employed:
      return 'EMPLOYED';
    case OnboardingOccupationalStatus.unemployed:
      return 'UNEMPLOYED';
    case OnboardingOccupationalStatus.apprentice:
      return 'APPRENTICE';
    case OnboardingOccupationalStatus.retired:
      return 'RETIRED';
    case OnboardingOccupationalStatus.student:
      return 'STUDENT';
  }
}
