import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _searchController = IvoryTextFieldController();
    _filteredCountries = countries;
    _searchController.addListener(filterCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  filterCountries() {
    setState(() {
      _filteredCountries = countries
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
              label: "Search prefix or country...",
              prefix: const Icon(Icons.search),
            ),
          ),
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
                          Image.asset(
                            country.flagPath,
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '${country.phonePrefix} (${country.name})',
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

  List<CountryPrefixItem> countries = [
    CountryPrefixItem(name: "Germany", flagPath: "assets/images/country_flags/germany.png", phonePrefix: "+49"),
    CountryPrefixItem(name: "Afghanistan", flagPath: "assets/images/country_flags/afghanistan.png", phonePrefix: "+93"),
    CountryPrefixItem(name: "Algeria", flagPath: "assets/images/country_flags/algeria.png", phonePrefix: "+213"),
    CountryPrefixItem(name: "Andorra", flagPath: "assets/images/country_flags/andorra.png", phonePrefix: "+376"),
    CountryPrefixItem(name: "Angola", flagPath: "assets/images/country_flags/angola.png", phonePrefix: "+244"),
    CountryPrefixItem(name: "Argentina", flagPath: "assets/images/country_flags/argentina.png", phonePrefix: "+54"),
    CountryPrefixItem(name: "Armenia", flagPath: "assets/images/country_flags/armenia.png", phonePrefix: "+374"),
    CountryPrefixItem(name: "Australia", flagPath: "assets/images/country_flags/australia.png", phonePrefix: "+61"),
    CountryPrefixItem(name: "Albania", flagPath: "assets/images/country_flags/albania.png", phonePrefix: "+355"),
  ];
}

class CountryPrefixItem {
  final String name;
  final String flagPath;
  final String phonePrefix;

  CountryPrefixItem({
    required this.name,
    required this.flagPath,
    required this.phonePrefix,
  });
}
