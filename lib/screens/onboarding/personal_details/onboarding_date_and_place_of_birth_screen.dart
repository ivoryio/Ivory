import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
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
  late List<SelectOption> _countries;
  final IvoryTextFieldController _dateOfBirthController = IvoryTextFieldController();
  final IvorySelectOptionController _selectCountryController = IvorySelectOptionController(loading: true);

  @override
  void initState() {
    super.initState();

    _loadCuntries();
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
                    placeholder: "DD / MM / YYYY",
                    bottomSheetTitle: "Select your date of birth",
                    controller: _dateOfBirthController,
                    inputType: TextFieldInputType.date,
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: "Country of birth",
                    placeholder: "Select country of birth",
                    bottomSheetTitle: "Select your country of birth",
                    searchFieldPlaceholder: "Search country...",
                    enabledSearch: true,
                    controller: _selectCountryController,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    onOptionSelected: (option) {},
                  ),
                  const Spacer(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(text: "Continue", onPressed: () {}),
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

  Future<void> _loadCuntries() async {
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

    setState(() {
      _countries = options;
    });

    _selectCountryController.setLoading(false);
  }
}
