import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/suggestions/city/city_suggestions_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/redux/suggestions/city/city_suggestions_action.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_adress_of_residence_screen.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_nationality_not_supported_screen.dart';
import 'package:solarisdemo/utilities/debouncer.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
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

  final _debouncer = Debouncer(seconds: 1);

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

  bool _notValidNationality() {
    return _selectNationalityController.selectedOptions.first.value != "DE";
  }

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    _selectCountryController.dispose();
    _selectCityController.dispose();
    _selectNationalityController.dispose();
    _continueButtonController.dispose();
    _debouncer.cancel();

    super.dispose();
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
                    optionSeparatorBuilder: (context, option) => option.value == "DE"
                        ? Divider(height: 2, color: ClientConfig.getCustomColors().neutral200)
                        : const SizedBox(),
                    enabledSearch: true,
                    bottomSheetExpanded: true,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    onOptionSelected: (option) {
                      _selectCityController.reset();

                      onChanged();
                      if (_selectCountryController.selectedOptions.isEmpty) {
                        _selectCityController.setEnabled(false);
                        return;
                      }

                      final countryCode = option.value;
                      StoreProvider.of<AppState>(context).dispatch(
                        FetchCitySuggestionsCommandAction(countryCode: countryCode),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  StoreConnector<AppState, CitySuggestionsViewModel>(
                    converter: (store) => CitySuggestionsPresenter.present(
                      citySuggestionsState: store.state.citySuggestionsState,
                    ),
                    distinct: true,
                    onWillChange: (previousViewModel, newViewModel) {
                      if (newViewModel is CitySuggestionsLoadingViewModel) {
                        _selectCityController.setOptions([]);
                        _selectCityController.setLoading(true);
                        _selectCityController.setEnabled(false);
                      } else if (newViewModel is CitySuggestionsFetchedViewModel) {
                        _selectCityController.setOptions(newViewModel.cities
                            .map((city) => SelectOption(
                                  textLabel: city,
                                  value: city,
                                ))
                            .toList());
                        _selectCityController.setLoading(false);
                        _selectCityController.setEnabled(true);
                      } else if (newViewModel is CitySuggestionsErrorViewModel) {
                        _selectCityController.setOptions([]);
                        _selectCityController.setLoading(false);
                        _selectCityController.setEnabled(false);
                        showBottomModal(
                          context: context,
                          showCloseButton: false,
                          title: "Server error",
                          content: Column(
                            children: [
                              Text.rich(
                                TextSpan(
                                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                  children: [
                                    const TextSpan(
                                      text:
                                          "We encountered an unexpected error while loading the “City of birth” list. Please try again. If the issue persists, please contact our support team at ",
                                    ),
                                    TextSpan(
                                      text: "+49 (0)123 456789",
                                      style: ClientConfig.getTextStyleScheme()
                                          .bodyLargeRegularBold
                                          .copyWith(color: ClientConfig.getColorScheme().secondary),
                                    ),
                                    const TextSpan(text: "."),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                text: "Try again",
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (_selectCountryController.selectedOptions.isEmpty) {
                                    return;
                                  }

                                  StoreProvider.of<AppState>(context).dispatch(
                                    FetchCitySuggestionsCommandAction(
                                      countryCode: _selectCountryController.selectedOptions.first.value,
                                      searchTerm: newViewModel.searchTerm,
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
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
                      bottomSheetExpanded: true,
                      searchFieldInitialText: viewModel is CitySuggestionsFetchedViewModel
                          ? viewModel.searchTerm ?? ""
                          : viewModel is CitySuggestionsFetchedViewModel
                              ? viewModel.searchTerm ?? ""
                              : "",
                      onOptionSelected: (option) {
                        onChanged();
                      },
                      onSearchChanged: (value) {
                        _debouncer.run(() {
                          _selectCityController.setLoading(true);

                          StoreProvider.of<AppState>(context).dispatch(
                            FetchCitySuggestionsCommandAction(
                              countryCode: _selectCountryController.selectedOptions.first.value,
                              searchTerm: value,
                            ),
                          );
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
                    optionSeparatorBuilder: (context, option) => option.value == "DE"
                        ? Divider(height: 2, color: ClientConfig.getCustomColors().neutral200)
                        : const SizedBox(),
                    enabledSearch: true,
                    bottomSheetExpanded: true,
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
                                  if (_notValidNationality()) {
                                    Navigator.pushNamed(context, OnboardingNationalityNotSupportedScreen.routeName);
                                    return;
                                  }

                                  StoreProvider.of<AppState>(context).dispatch(
                                    SubmitOnboardingBirthInfoCommandAction(
                                      birthDate: _dateOfBirthController.text,
                                      country: _selectCountryController.selectedOptions.first.value,
                                      city: _selectCityController.selectedOptions.first.value,
                                      nationality: _selectNationalityController.selectedOptions.first.value,
                                    ),
                                  );

                                  Navigator.pushNamed(context, OnboardingAddressOfResidenceScreen.routeName);
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
    print("Countries loaded");
    _selectCountryController.setLoading(false);
    _selectNationalityController.setLoading(false);
  }
}
