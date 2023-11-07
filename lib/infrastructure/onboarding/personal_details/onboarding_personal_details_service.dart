import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/models/suggestions/address_suggestion.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class OnboardingPersonalDetailsService extends ApiService {
  OnboardingPersonalDetailsService({super.user});

  Future<OnboardingPersonalDetailsServiceResponse> createPerson({
    required User user,
    required AddressSuggestion address,
    required String birthDate,
    required String birthCity,
    required String birthCountry,
    required String nationality,
  }) async {
    this.user = user;

    try {
      final response = await post('/signup/person', body: {
        'address': {
          'line_1': address.address,
          'line_2': "",
          'postal_code': "44135", // TODO: get postal code from address
          'city': address.city,
          'country': await _isoCodeFromCountryName(address.country),
        },
        'birthDate': birthDate,
        'birthCity': birthCity,
        'nationality': nationality,
      });

      return OnboardingCreatePersonSuccessResponse(personId: response['person_id'] as String);
    } catch (error) {
      return OnboardingPersonalDetailsServiceErrorResponse(errorType: OnboardingPersonalDetailsErrorType.unknown);
    }
  }
}

abstract class OnboardingPersonalDetailsServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingCreatePersonSuccessResponse extends OnboardingPersonalDetailsServiceResponse {
  final String personId;

  OnboardingCreatePersonSuccessResponse({required this.personId});

  @override
  List<Object?> get props => [personId];
}

class OnboardingPersonalDetailsServiceErrorResponse extends OnboardingPersonalDetailsServiceResponse {
  final OnboardingPersonalDetailsErrorType errorType;

  OnboardingPersonalDetailsServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

Future<String> _isoCodeFromCountryName(String countryName) async {
  final countriesJson = await rootBundle.loadString('assets/data/countries.json');
  final countries = jsonDecode(countriesJson);

  for (var country in countries) {
    if (country['name'] == countryName) {
      return country['isoCode'];
    }
  }

  return "";
}
