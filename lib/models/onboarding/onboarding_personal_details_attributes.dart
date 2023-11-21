import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';

class OnboardingPersonalDetailsAttributes extends Equatable {
  final String? birthDate;
  final String? country;
  final String? city;
  final String? nationality;
  final AddressSuggestion? selectedAddress;
  final String? mobileNumber;

  const OnboardingPersonalDetailsAttributes({
    this.birthDate,
    this.country,
    this.city,
    this.nationality,
    this.selectedAddress,
    this.mobileNumber,
  });

  bool get hasBirthInfo => birthDate != null && country != null && city != null && nationality != null;

  @override
  List<Object?> get props => [birthDate, country, city, nationality, selectedAddress, mobileNumber];

  OnboardingPersonalDetailsAttributes copyWith({
    bool useNull = false,
    String? birthDate,
    String? country,
    String? city,
    String? nationality,
    AddressSuggestion? selectedAddress,
    String? mobileNumber,
  }) {
    return OnboardingPersonalDetailsAttributes(
      birthDate: useNull ? birthDate : birthDate ?? this.birthDate,
      country: useNull ? country : country ?? this.country,
      city: useNull ? city : city ?? this.city,
      nationality: useNull ? nationality : nationality ?? this.nationality,
      selectedAddress: useNull ? selectedAddress : selectedAddress ?? this.selectedAddress,
      mobileNumber: useNull ? mobileNumber : mobileNumber ?? this.mobileNumber,
    );
  }
}
