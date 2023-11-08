import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';

class OnboardingPersonalDetailsAttributes extends Equatable {
  final String? birthDate;
  final String? country;
  final String? city;
  final String? nationality;
  final AddressSuggestion? selectedAddress;
  final int? houseNumber;
  final String? addressLine;
  final String? postCode;
  final String? mobileNumber;

  const OnboardingPersonalDetailsAttributes({
    this.birthDate,
    this.country,
    this.city,
    this.nationality,
    this.selectedAddress,
    this.houseNumber,
    this.addressLine,
    this.postCode,
    this.mobileNumber,
  });

  bool get hasBirthInfo => birthDate != null && country != null && city != null && nationality != null;

  @override
  List<Object?> get props =>
      [birthDate, country, city, nationality, selectedAddress, houseNumber, addressLine, postCode, mobileNumber];

  OnboardingPersonalDetailsAttributes copyWith({
    String? birthDate,
    String? country,
    String? city,
    String? nationality,
    AddressSuggestion? selectedAddress,
    int? houseNumber,
    String? addressLine,
    String? postCode,
    String? mobileNumber,
  }) {
    return OnboardingPersonalDetailsAttributes(
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      city: city ?? this.city,
      nationality: nationality ?? this.nationality,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      houseNumber: houseNumber ?? this.houseNumber,
      addressLine: addressLine ?? this.addressLine,
      postCode: postCode ?? this.postCode,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
