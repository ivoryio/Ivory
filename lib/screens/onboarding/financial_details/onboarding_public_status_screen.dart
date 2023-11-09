import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
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
            actions: const [AppbarLogo()],
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
                    options: const [
                      SelectOption(textLabel: 'Not married', value: 'notmarried'),
                      SelectOption(textLabel: 'Married', value: 'married'),
                      SelectOption(textLabel: 'Divorced', value: 'divorced'),
                      SelectOption(textLabel: 'Widowed', value: 'widowed'),
                      SelectOption(textLabel: 'Prefer not to say', value: 'prefernotosay'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvorySelectOption(
                    label: 'Living situation',
                    bottomSheetTitle: 'Select your living situation',
                    controller: _selectLivingController,
                    options: const [
                      SelectOption(textLabel: 'I live in my own home', value: 'livininmyhome'),
                      SelectOption(textLabel: 'I live in a rented home', value: 'livinginrentedhome'),
                      SelectOption(textLabel: 'I live with my parents', value: 'livingwithparents'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  IvoryTextField(
                    label: 'Number of dependents',
                    controller: _dependentsController,
                    keyboardType: TextInputType.number,
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
                                Navigator.pushNamed(context, WelcomeScreen.routeName);
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
