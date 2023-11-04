import 'package:equatable/equatable.dart';

class OnboardingPersonalDetailsAttributes extends Equatable {
  final String? birthDate;
  final String? country;
  final String? city;
  final String? nationality;
  final String? address;
  final int? houseNumber;
  final String? addressLine;
  final String? postCode;

  const OnboardingPersonalDetailsAttributes({
    this.birthDate,
    this.country,
    this.city,
    this.nationality,
    this.address,
    this.houseNumber,
    this.addressLine,
    this.postCode,
  });

  @override
  List<Object?> get props => [birthDate, country, city, nationality, address, houseNumber, addressLine, postCode];

  OnboardingPersonalDetailsAttributes copyWith({
    String? birthDate,
    String? country,
    String? city,
    String? nationality,
    String? address,
    int? houseNumber,
    String? addressLine,
    String? postCode,
  }) {
    return OnboardingPersonalDetailsAttributes(
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      city: city ?? this.city,
      nationality: nationality ?? this.nationality,
      address: address ?? this.address,
      houseNumber: houseNumber ?? this.houseNumber,
      addressLine: addressLine ?? this.addressLine,
      postCode: postCode ?? this.postCode,
    );
  }
}
