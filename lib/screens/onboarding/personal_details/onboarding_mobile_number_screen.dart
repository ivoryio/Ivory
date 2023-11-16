import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/screens/login/modals/mobile_number_country_picker_popup.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_verify_mobile_number_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
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
  late ContinueButtonController _continueButtonController;
  late MaskTextInputFormatter _phoneNumberFormatter;

  @override
  void initState() {
    _mobileNumberController = IvoryTextFieldController(text: CountryPrefixItem.defaultCountryPrefix.phoneCode);
    _mobileNumberController.addListener(onChanged);
    _mobileNumberFocusNode = FocusNode();
    _continueButtonController = ContinueButtonController();
    _selectedCountryNotifier = ValueNotifier<CountryPrefixItem>(CountryPrefixItem.defaultCountryPrefix);

    _phoneNumberFormatter = InputFormatter.createPhoneNumberFormatter(
      _selectedCountryNotifier.value.phoneNumberFormat!,
    );
    super.initState();
  }

  void onChanged() {
    if (_selectedCountryNotifier.value.phoneNumberFormat == null) {
      _continueButtonController.setEnabled();
      return;
    }
    final formattedText = _phoneNumberFormatter.getUnmaskedText();

    if (formattedText.length ==
        _selectedCountryNotifier.value.phoneNumberFormat!.split('').where((char) => char == '#').length) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingPersonalDetailsViewModel>(
      converter: (store) => OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
        onboardingPersonalDetailsState: store.state.onboardingPersonalDetailsState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isLoading) {
          _continueButtonController.setLoading();
        }
        if (previousViewModel!.attributes.mobileNumber != newViewModel.attributes.mobileNumber) {
          Navigator.pushNamed(context, OnboardingVerifyMobileNumberScreen.routeName);
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                backButtonEnabled: false,
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
                            inputFormatters: selectedCountry.phoneNumberFormat != null
                                ? [
                                    _phoneNumberFormatter,
                                  ]
                                : null,
                            inputType: TextFieldInputType.number,
                            controller: _mobileNumberController,
                            focusNode: _mobileNumberFocusNode,
                            prefix: GestureDetector(
                              onTap: () {
                                _mobileNumberFocusNode.unfocus();
                                showBottomModal(
                                  addContentPadding: false,
                                  context: context,
                                  title: "Select mobile number prefix",
                                  content: CountryPrefixPicker(
                                    onCountrySelected: (country) {
                                      _selectedCountryNotifier.value = country;
                                      _mobileNumberController.text = country.phoneCode;
                                      _phoneNumberFormatter = InputFormatter.createPhoneNumberFormatter(
                                        country.phoneNumberFormat!,
                                      );
                                    },
                                    selectedCountry: _selectedCountryNotifier.value,
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 48,
                                width: 60,
                                child: Row(
                                  children: [
                                    Text(
                                      selectedCountry.flag,
                                      style: const TextStyle(fontSize: 20, height: 24 / 20),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.expand_more,
                                      color: ClientConfig.getCustomColors().neutral700,
                                    ),
                                    SizedBox(
                                      width: 1,
                                      child: VerticalDivider(
                                        color: _mobileNumberFocusNode.hasFocus
                                            ? ClientConfig.getCustomColors().neutral900
                                            : ClientConfig.getCustomColors().neutral400,
                                        thickness: 1,
                                        
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: ListenableBuilder(
                          listenable: _continueButtonController,
                          builder: (context, child) {
                            return PrimaryButton(
                              text: "Continue",
                              isLoading: _continueButtonController.isLoading,
                              onPressed: _continueButtonController.isEnabled
                                  ? () {
                                      _mobileNumberFocusNode.unfocus();
                                      _continueButtonController.setLoading();
                                      StoreProvider.of<AppState>(context).dispatch(
                                        CreateMobileNumberCommandAction(
                                          mobileNumber: _selectedCountryNotifier.value.phoneCode +
                                              _phoneNumberFormatter.getUnmaskedText(),
                                        ),
                                      );
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
      },
    );
  }
}
