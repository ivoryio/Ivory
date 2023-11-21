import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_monthly_income_screen.dart';
import 'package:solarisdemo/utilities/validator.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingOccupationalStatusScreen extends StatefulWidget {
  static const routeName = '/onboardingOccupationalStatusScreen';

  const OnboardingOccupationalStatusScreen({super.key});

  @override
  State<OnboardingOccupationalStatusScreen> createState() => _OnboardingOccupationalStatusScreenState();
}

class _OnboardingOccupationalStatusScreenState extends State<OnboardingOccupationalStatusScreen> {
  final IvorySelectOptionController _occupationController = IvorySelectOptionController();
  final IvoryTextFieldController _dateOfEmploymentController = IvoryTextFieldController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _occupationController.addListener(onChanged);
    _dateOfEmploymentController.addListener(onChanged);
  }

  onChanged() {
    if (_occupationController.selectedOptions.isEmpty) {
      _continueButtonController.setDisabled();
    }

    final selectedValue = _occupationController.selectedOptions.firstOrNull?.value;

    if (['unemployed', 'apprentice', 'retired', 'student'].contains(selectedValue)) {
      _continueButtonController.setEnabled();
    }

    if (selectedValue == "employed") {
      if (_dateOfEmploymentController.text.isNotEmpty) {
        _continueButtonController.setEnabled();
      } else {
        _continueButtonController.setDisabled();
      }
    }
  }

  @override
  void dispose() {
    _occupationController.dispose();
    _dateOfEmploymentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 4, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 4, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Occupation', style: ClientConfig.getTextStyleScheme().heading2),
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: 'Occupational status',
                    bottomSheetTitle: 'Select your occupational status',
                    placeholder: 'Select occupational status',
                    controller: _occupationController,
                    onBottomSheetOpened: () => FocusScope.of(context).unfocus(),
                    options: [
                      SelectOption(textLabel: 'Employed', value: OnboardingOccupationalStatus.employed.name),
                      SelectOption(textLabel: 'Unemployed', value: OnboardingOccupationalStatus.unemployed.name),
                      SelectOption(textLabel: 'Apprentice', value: OnboardingOccupationalStatus.apprentice.name),
                      SelectOption(textLabel: 'Retired', value: OnboardingOccupationalStatus.retired.name),
                      SelectOption(textLabel: 'Student', value: OnboardingOccupationalStatus.student.name),
                    ],
                  ),
                  ListenableBuilder(
                    listenable: _occupationController,
                    builder: (context, child) {
                      if (_occupationController.selectedOptions.firstOrNull?.value == 'employed') {
                        return _buildEmployedStatus();
                      }

                      return const SizedBox();
                    },
                  ),
                  const Spacer(),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => PrimaryButton(
                        text: "Continue",
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled
                            ? () {
                                if (!Validator.isValidDate(_dateOfEmploymentController.text,
                                    pattern: textFieldDatePattern)) {
                                  _dateOfEmploymentController.setErrorText("Invalid date of employment");
                                  _continueButtonController.setDisabled();
                                  return;
                                }

                                _dateOfEmploymentController.setError(false);

                                if (_occupationController.selectedOptions.firstOrNull?.value == 'employed') {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(CreateEmployedOccupationalStatusCommandAction(
                                    occupationalStatus: OnboardingOccupationalStatus.employed,
                                    dateOfEmployment: _dateOfEmploymentController.text,
                                  ));
                                } else {
                                  StoreProvider.of<AppState>(context).dispatch(
                                    CreateOthersOccupationalStatusCommandAction(
                                      occupationalStatus: OnboardingOccupationalStatus.values.firstWhere((element) =>
                                          element.name == _occupationController.selectedOptions.first.value),
                                    ),
                                  );
                                }

                                Navigator.of(context).pushNamed(OnboardingMonthlyIncomeScreen.routeName);
                              }
                            : null),
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

  Widget _buildEmployedStatus() {
    return Column(
      children: [
        const SizedBox(height: 16),
        IvoryTextField(
          label: "Current employment start date",
          placeholder: "DD/MM/YYYY",
          bottomSheetTitle: "Select the employment start date",
          controller: _dateOfEmploymentController,
          inputType: TextFieldInputType.date,
        ),
      ],
    );
  }
}
