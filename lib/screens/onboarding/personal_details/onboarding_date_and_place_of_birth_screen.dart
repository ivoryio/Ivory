import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/search/search_cities_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/search/search_cities_action.dart';
import 'package:solarisdemo/utilities/debouncer.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingDateAndPlaceOfBirthScreen extends StatefulWidget {
  static const routeName = '/onboardingDateAndPlaceOfBirthScreen';

  const OnboardingDateAndPlaceOfBirthScreen({super.key});

  @override
  State<OnboardingDateAndPlaceOfBirthScreen> createState() => _OnboardingDateAndPlaceOfBirthScreenState();
}

class _OnboardingDateAndPlaceOfBirthScreenState extends State<OnboardingDateAndPlaceOfBirthScreen> {
  final IvoryTextFieldController _dateOfBirthController = IvoryTextFieldController();
  final IvorySelectOptionController _selectCountryController = IvorySelectOptionController(loading: true);
  final IvorySelectOptionController _selectCityController = IvorySelectOptionController(enabled: false);
  final IvorySelectOptionController _selectNationalityController = IvorySelectOptionController(loading: true);
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();

    _loadCountries();
  }

  void onChanged() {
    if (_dateOfBirthController.text.isNotEmpty &&
        _selectCountryController.selectedOptions.isNotEmpty &&
        _selectCityController.selectedOptions.isNotEmpty &&
        _selectNationalityController.selectedOptions.isNotEmpty) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 4),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text("Date & place of birth", style: ClientConfig.getTextStyleScheme().heading2),
                  const SizedBox(height: 16),
                  Text(
                    "Enter your date of birth and country of birth below.",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: "Date of birth",
                    placeholder: "DD/MM/YYYY",
                    bottomSheetTitle: "Select your date of birth",
                    controller: _dateOfBirthController,
                    inputType: TextFieldInputType.date,
                    onChanged: (input) => onChanged(),
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: "Country of birth",
                    placeholder: "Select country of birth",
                    bottomSheetTitle: "Select your country of birth",
                    searchFieldPlaceholder: "Search country...",
                    controller: _selectCountryController,
                    enabledSearch: true,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    onOptionSelected: (option) {
                      final countryCode = option.value;
                      _selectCityController.reset();
                      StoreProvider.of<AppState>(context).dispatch(FetchCitiesCommandAction(countryCode: countryCode));
                      onChanged();
                    },
                  ),
                  const SizedBox(height: 24),
                  StoreConnector<AppState, SearchCitiesViewModel>(
                    converter: (store) => SearchCitiesPresenter.present(
                      searchCitiesState: store.state.searchCitiesState,
                    ),
                    onWillChange: (previousViewModel, newViewModel) {
                      if (newViewModel is SearchCitiesLoadingViewModel) {
                        _selectCityController.setLoading(true);
                        _selectCityController.setEnabled(false);
                      } else if (newViewModel is SearchCitiesFetchedViewModel) {
                        _selectCityController.setOptions(newViewModel.cities
                            .map((city) => SelectOption(
                                  textLabel: city,
                                  value: city,
                                ))
                            .toList());
                        _selectCityController.setLoading(false);
                        _selectCityController.setEnabled(true);
                      }
                    },
                    builder: (context, viewModel) => IvorySelectOption(
                      label: "City of birth",
                      placeholder: "Select city of birth",
                      bottomSheetTitle: "Select your city of birth",
                      searchFieldPlaceholder: "Search city...",
                      controller: _selectCityController,
                      enabledSearch: true,
                      filterOptions: false,
                      onOptionSelected: (option) {
                        onChanged();
                      },
                      onSearchChanged: (value) {
                        _debouncer.run(() {
                          if (value.isNotEmpty) {
                            _selectCityController.setLoading(true);
                            StoreProvider.of<AppState>(context).dispatch(
                              FetchCitiesCommandAction(
                                countryCode: _selectCountryController.selectedOptions.first.value,
                                searchTerm: value,
                              ),
                            );
                          }
                        });
                      },
                      onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: "Nationality",
                    placeholder: "Select nationality",
                    bottomSheetTitle: "Select your nationality",
                    searchFieldPlaceholder: "Search nationality...",
                    controller: _selectNationalityController,
                    enabledSearch: true,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    onOptionSelected: (option) => onChanged(),
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ListenableBuilder(
                      listenable: _continueButtonController,
                      builder: (context, child) {
                        return PrimaryButton(
                          text: "Continue",
                          onPressed: _continueButtonController.isEnabled
                              ? () {
                                  print("Date of birth: ${_dateOfBirthController.text}");
                                  print("Selected country: ${_selectCountryController.selectedOptions.first.value}");
                                }
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadCountries() async {
    final countriesJson = await rootBundle.loadString('assets/data/countries.json');
    final countries = jsonDecode(countriesJson);
    final List<SelectOption> options = List.empty(growable: true);

    for (final country in countries) {
      options.add(
        SelectOption(
          textLabel: country['name'],
          value: country['isoCode'],
          prefix: Text(
            "${country['flag']} ",
            style: const TextStyle(fontSize: 20, height: 24 / 20),
          ),
        ),
      );
    }
    _selectCountryController.setOptions(options);
    _selectNationalityController.setOptions(options);

    _selectCountryController.setLoading(false);
    _selectNationalityController.setLoading(false);
  }
}
