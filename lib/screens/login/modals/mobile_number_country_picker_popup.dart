import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';

class CountryPrefixPicker extends StatefulWidget {
  final void Function(CountryPrefixItem country) onCountrySelected;
  final CountryPrefixItem? selectedCountry;

  const CountryPrefixPicker({
    super.key,
    required this.onCountrySelected,
    required this.selectedCountry,
  });

  @override
  State<CountryPrefixPicker> createState() => _CountryPrefixPickerState();
}

class _CountryPrefixPickerState extends State<CountryPrefixPicker> {
  late IvoryTextFieldController _searchController;
  late List<CountryPrefixItem> _filteredCountries;
  late List<CountryPrefixItem> _countries;

  @override
  void initState() {
    super.initState();
    _searchController = IvoryTextFieldController();
    _filteredCountries = List.empty(growable: true);
    _countries = List.empty(growable: true);
    _loadCountries();
    _searchController.addListener(filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  filterCountries() {
    setState(() {
      _filteredCountries = _countries
          .where((country) => country.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: IvoryTextField(
              controller: _searchController,
              placeholder: 'Search prefix or country...',
              suffix: Icon(Icons.search, color: ClientConfig.getCustomColors().neutral700),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final bool isSelected = widget.selectedCountry?.name == country.name;
                return Container(
                  decoration: BoxDecoration(
                    color: isSelected ? ClientConfig.getCustomColors().neutral100 : Colors.transparent,
                    border: isSelected
                        ? Border(
                            bottom: BorderSide(
                              color: ClientConfig.getCustomColors().neutral200,
                              width: 1,
                            ),
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        widget.onCountrySelected(country);
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Text(
                            country.flag,
                            style: const TextStyle(fontSize: 20, height: 24 / 20),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${country.phoneCode} (${country.name})',
                            style: ClientConfig.getTextStyleScheme().heading4,
                          ),
                          const SizedBox(width: 16),
                          const Spacer(),
                          if (isSelected)
                            Icon(
                              Icons.check,
                              color: ClientConfig.getCustomColors().success,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadCountries() async {
    final String countriesJson = await rootBundle.loadString('assets/data/countries.json');
    final List<dynamic> countriesData = jsonDecode(countriesJson);
    final List<CountryPrefixItem> options = countriesData.map((country) {
      return CountryPrefixItem(
        name: country['name'],
        phoneCode: country['phoneCode'],
        phoneNumberFormat: country['phoneNumberFormat'],
        flag: country['flag'],
      );
    }).toList();

    if (widget.selectedCountry != null) {
      options.removeWhere((item) => item.name == widget.selectedCountry!.name);
      options.insert(0, widget.selectedCountry!);
    }

    setState(() {
      _countries = options;
      _filteredCountries = options;
    });
  }
}

class CountryPrefixItem {
  final String name;
  final String flag;
  final String phoneCode;
  final String? phoneNumberFormat;

  CountryPrefixItem({
    required this.name,
    required this.flag,
    required this.phoneCode,
    this.phoneNumberFormat,
  });

  static CountryPrefixItem defaultCountryPrefix = CountryPrefixItem(
    name: "Germany",
    flag: "🇩🇪",
    phoneCode: "+49",
    phoneNumberFormat: "+49(##) #######",
  );
}
