import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/models/select_option.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/screens/onboarding/personal_details/onboarding_verify_mobile_number_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/utilities/load_countries.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_option_picker.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

const minFormatterLength = 3;

class OnboardingMobileNumberScreen extends StatefulWidget {
  static const routeName = '/onboardingMobileNumberScreen';

  const OnboardingMobileNumberScreen({super.key});

  @override
  State<OnboardingMobileNumberScreen> createState() => _OnboardingMobileNumberScreenState();
}

class _OnboardingMobileNumberScreenState extends State<OnboardingMobileNumberScreen> {
  late IvoryTextFieldController _mobileNumberController;
  late FocusNode _mobileNumberFocusNode;
  late ContinueButtonController _continueButtonController;
  late MaskTextInputFormatter _phoneNumberFormatter;
  late IvorySelectOptionController _countrySelectOptionController;

  @override
  void initState() {
    FlutterNativeSplash.remove();
    _mobileNumberController = IvoryTextFieldController();
    _mobileNumberController.addListener(onChanged);
    _mobileNumberFocusNode = FocusNode();
    _continueButtonController = ContinueButtonController();
    _countrySelectOptionController = IvorySelectOptionController(loading: true);
    _phoneNumberFormatter = InputFormatter.createPhoneNumberFormatter("");

    _loadCountryOptions();

    super.initState();
  }

  Future<void> _loadCountryOptions() async {
    final List<SelectOption> options = await loadCountryPickerOptions(addPhoneCode: true);

    final preselectedOption = options.first;
    final phoneCode = preselectedOption.getPhoneCode() ?? "";
    final phoneNumberFormat = preselectedOption.getPhoneNumberFormat() ?? "";

    _countrySelectOptionController.setOptions(options);
    _countrySelectOptionController.toggleOptionSelection(preselectedOption, 0);
    _mobileNumberController.text = phoneCode;
    _phoneNumberFormatter = InputFormatter.createPhoneNumberFormatter(phoneNumberFormat);
  }

  void onChanged() {
    final phoneNumberFormat = _countrySelectOptionController.firstSelectedOption?.getPhoneNumberFormat() ?? "";
    if (phoneNumberFormat.length < minFormatterLength) {
      _continueButtonController.setEnabled();
      return;
    }

    final formattedText = _phoneNumberFormatter.getUnmaskedText();
    if (formattedText.length == phoneNumberFormat.split('').where((char) => char == '#').length) {
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
                      ListenableBuilder(
                        listenable: _countrySelectOptionController,
                        builder: (context, child) {
                          return IvoryTextField(
                            label: 'Mobile number',
                            keyboardType: TextInputType.phone,
                            inputFormatters: _countrySelectOptionController.selectedOptions.firstOrNull != null &&
                                    _countrySelectOptionController.selectedOptions.first.getPhoneNumberFormat() != null
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
                                  context: context,
                                  title: "Select mobile number prefix",
                                  addContentPadding: false,
                                  useSafeArea: true,
                                  statusbarVisibilityForTallModal: true,
                                  useScrollableChild: false,
                                  content: IvoryOptionPicker(
                                    controller: _countrySelectOptionController,
                                    filterOptions: true,
                                    enabledSearch: true,
                                    searchFieldPlaceholder: 'Search prefix or country...',
                                    onSearchChanged: (value) {},
                                    expanded: true,
                                    onOptionSelected: (option) {
                                      final phoneCode = option.getPhoneCode() ?? "";
                                      final phoneNumberFormat = option.getPhoneNumberFormat() ?? "";

                                      _mobileNumberController.text = phoneCode;

                                      setState(() {
                                        _phoneNumberFormatter = InputFormatter.createPhoneNumberFormatter(
                                          phoneNumberFormat,
                                        );
                                      });

                                      onChanged();
                                    },
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 48,
                                width: 65,
                                child: Row(
                                  children: [
                                    _countrySelectOptionController.firstSelectedOption?.prefix ?? const SizedBox(),
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
                                      final mobileNumber =
                                          '${_countrySelectOptionController.firstSelectedOption?.getPhoneCode() ?? ""}${_phoneNumberFormatter.getUnmaskedText()}';

                                      _mobileNumberFocusNode.unfocus();
                                      _continueButtonController.setLoading();
                                      print("Mobile number: $mobileNumber");

                                      StoreProvider.of<AppState>(context).dispatch(
                                        CreateMobileNumberCommandAction(mobileNumber: mobileNumber),
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
