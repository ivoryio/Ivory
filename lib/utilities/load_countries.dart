import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/models/select_option.dart';

Future<List> loadCountries() async {
  final countriesJson = await rootBundle.loadString('assets/data/countries.json');
  final countries = jsonDecode(countriesJson) as List;

  log("Countries loaded: ${countries.length}");

  return countries;
}

Future<List<SelectOption>> loadCountryPickerOptions({bool addPhoneCode = false}) async {
  final countries = await loadCountries();
  final List<SelectOption> options = [];

  for (final country in countries) {
    final phoneCode = country["phoneCode"] ?? "";
    final phoneNumberFormat = country["phoneNumberFormat"] ?? "";

    options.add(
      SelectOption(
        textLabel: addPhoneCode ? '$phoneCode (${country["name"]})' : country["name"],
        value: country["isoCode"],
        prefix: Text(
          "${country['flag']} ",
          style: const TextStyle(fontSize: 20, height: 24 / 20),
        ),
        data: {
          "phoneCode": phoneCode,
          "phoneNumberFormat": phoneNumberFormat,
        },
      ),
    );
  }

  return options;
}
