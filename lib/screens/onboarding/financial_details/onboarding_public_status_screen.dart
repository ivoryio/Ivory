import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingPublicStatusScreen extends StatefulWidget {
  static const routeName = '/onboardingPublicStatusScreen';

  const OnboardingPublicStatusScreen({super.key});

  @override
  State<OnboardingPublicStatusScreen> createState() => _OnboardingPublicStatusScreenState();
}

class _OnboardingPublicStatusScreenState extends State<OnboardingPublicStatusScreen> {
  final IvorySelectOptionController _selectMaritalController = IvorySelectOptionController();
  final IvorySelectOptionController _selectLivingController = IvorySelectOptionController();
  final IvoryTextFieldController _dependentsController = IvoryTextFieldController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _selectMaritalController.addListener(onChange);
    _selectLivingController.addListener(onChange);
    _dependentsController.addListener(onChange);
  }

  onChange() {
    if (_selectMaritalController.selectedOptions.isEmpty ||
        _selectLivingController.selectedOptions.isEmpty ||
        _dependentsController.text.isEmpty) {
      _continueButtonController.setDisabled();
    } else {
      _continueButtonController.setEnabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 3, totalSteps: 5),
            actions: const [
              AppbarLogo(),
            ],
            onBackButtonPressed: () {},
            backButtonEnabled: false,
          ),
          AnimatedLinearProgressIndicator.step(current: 3, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Marital status, living situation & dependents',
                        style: ClientConfig.getTextStyleScheme().heading2),
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: 'Marital status',
                    bottomSheetTitle: 'Select your marital status',
                    controller: _selectMaritalController,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    placeholder: 'Select marital status',
                    options: [
                      SelectOption(textLabel: 'Not married', value: OnboardingMaritalStatus.notMarried.name),
                      SelectOption(textLabel: 'Married', value: OnboardingMaritalStatus.married.name),
                      SelectOption(textLabel: 'Divorced', value: OnboardingMaritalStatus.divorced.name),
                      SelectOption(textLabel: 'Widowed', value: OnboardingMaritalStatus.widowed.name),
                      SelectOption(textLabel: 'Prefer not to say', value: OnboardingMaritalStatus.preferNotToSay.name),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: 'Living situation',
                    bottomSheetTitle: 'Select your living situation',
                    controller: _selectLivingController,
                    placeholder: 'Select living situation',
                    options: [
                      SelectOption(textLabel: 'I live in my own home', value: OnboardingLivingSituation.own.name),
                      SelectOption(textLabel: 'I live in a rented home', value: OnboardingLivingSituation.rent.name),
                      SelectOption(textLabel: 'I live with my parents', value: OnboardingLivingSituation.parents.name),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: 'Number of dependents',
                    labelSuffix: InkWell(
                      onTap: () {
                        showBottomModal(
                          context: context,
                          title: 'Number of dependents',
                          content: Text.rich(
                            TextSpan(
                              style: ClientConfig.getTextStyleScheme().mixedStyles,
                              children: [
                                const TextSpan(text: 'Dependents are '),
                                TextSpan(
                                    text:
                                        'individuals who rely on your financial support, such as children or other family members.',
                                    style: ClientConfig.getTextStyleScheme()
                                        .mixedStyles
                                        .copyWith(fontWeight: FontWeight.w600)),
                                const TextSpan(
                                    text:
                                        ' By providing this information, you help us understand your financial responsibilities, which can be important for determining your credit card limit and eligibility.\n\n'),
                                TextSpan(
                                    text: 'If you do not have any dependents, simply enter \'0\'',
                                    style: ClientConfig.getTextStyleScheme()
                                        .mixedStyles
                                        .copyWith(fontWeight: FontWeight.w600)),
                                const TextSpan(text: ' to indicate that you are financially independent.'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.info_outline, color: ClientConfig.getColorScheme().primary, size: 16),
                    ),
                    controller: _dependentsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    placeholder: 'Type number of dependents',
                  ),
                  const Spacer(),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) {
                      return PrimaryButton(
                        text: "Continue",
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled
                            ? () {
                                StoreProvider.of<AppState>(context).dispatch(CreatePublicStatusCommandAction(
                                  maritalAttributes: OnboardingMaritalStatus.values.firstWhere((element) =>
                                      element.name == _selectMaritalController.selectedOptions.first.value),
                                  livingAttributes: OnboardingLivingSituation.values.firstWhere(
                                      (element) => element.name == _selectLivingController.selectedOptions.first.value),
                                  numberOfDependents: int.parse(_dependentsController.text),
                                ));

                                // Navigator.pushNamed(context, OnboardingOccupationalStatusScreen.routeName);
                              }
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
