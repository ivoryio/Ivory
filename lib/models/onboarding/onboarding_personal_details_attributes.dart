import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';

class OnboardingPersonalDetailsAttributes extends Equatable {
  final String? birthDate;
  final String? country;
  final String? city;
  final String? nationality;
  final AddressSuggestion? selectedAddress;

  const OnboardingPersonalDetailsAttributes({
    this.birthDate,
    this.country,
    this.city,
    this.nationality,
    this.selectedAddress,
  });

  bool get hasBirthInfo => birthDate != null && country != null && city != null && nationality != null;

  @override
  List<Object?> get props => [birthDate, country, city, nationality, selectedAddress];

  OnboardingPersonalDetailsAttributes copyWith({
    String? birthDate,
    String? country,
    String? city,
    String? nationality,
    AddressSuggestion? selectedAddress,
  }) {
    return OnboardingPersonalDetailsAttributes(
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      city: city ?? this.city,
      nationality: nationality ?? this.nationality,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}
