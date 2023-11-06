import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/login/modals/mobile_number_country_picker_popup.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingMobileNumberScreen extends StatefulWidget {
  static const routeName = '/onboardingMobileNumberScreen';

  const OnboardingMobileNumberScreen({super.key});

  @override
  State<OnboardingMobileNumberScreen> createState() => _OnboardingMobileNumberScreenState();
}

class _OnboardingMobileNumberScreenState extends State<OnboardingMobileNumberScreen> {
  late IvoryTextFieldController _mobileNumberController;
  late FocusNode _mobileNumberFocusNode;
  late ValueNotifier<CountryPrefixItem> _selectedCountryNotifier;

  @override
  void initState() {
    _mobileNumberController = IvoryTextFieldController();
    _mobileNumberFocusNode = FocusNode();
    _selectedCountryNotifier = ValueNotifier<CountryPrefixItem>(
      CountryPrefixItem(
        name: "Germany",
        flagPath: "assets/images/germany_flag.png",
        phonePrefix: "+49",
      ),
    );
    super.initState();
  }

  Future<void> initCountries() async {
    final countriesJson = await rootBundle.loadString('assets/data/countries.json');
    final countries = jsonDecode(countriesJson);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 3, totalSteps: 4),
            actions: const [
              AppbarLogo(),
            ],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(
            current: 3,
            totalSteps: 4,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text('Mobile number', style: ClientConfig.getTextStyleScheme().heading2),
                  const SizedBox(height: 16),
                  Text(
                    'Fill in your mobile number below. We will verify it with a code in the next step.',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(height: 24),
                  ValueListenableBuilder<CountryPrefixItem>(
                    valueListenable: _selectedCountryNotifier,
                    builder: (context, selectedCountry, child) {
                      return IvoryTextField(
                        label: 'Mobile number',
                        keyboardType: TextInputType.phone,
                        controller: _mobileNumberController,
                        focusNode: _mobileNumberFocusNode,
                        prefix: GestureDetector(
                          onTap: () {
                            showBottomModal(
                              addContentPadding: false,
                              context: context,
                              title: "Select mobile number prefix",
                              content: CountryPrefixPicker(
                                onCountrySelected: (country) {
                                  _selectedCountryNotifier.value = country;
                                  _mobileNumberController.text = country.phonePrefix;
                                },
                                selectedCountry: _selectedCountryNotifier.value,
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 48,
                            width: 80,
                            child: Row(
                              children: [
                                Image.asset(selectedCountry.flagPath),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.expand_more,
                                  color: ClientConfig.getCustomColors().neutral700,
                                ),
                                VerticalDivider(
                                  color: _mobileNumberFocusNode.hasFocus
                                      ? ClientConfig.getCustomColors().neutral900
                                      : ClientConfig.getCustomColors().neutral400,
                                  thickness: 1,
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
