import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/welcome/welcome_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingTaxIdScreen extends StatefulWidget {
  static const routeName = '/onboardingTaxIDScreen';

  const OnboardingTaxIdScreen({super.key});

  @override
  State<OnboardingTaxIdScreen> createState() => _OnboardingTaxIdScreenState();
}

class _OnboardingTaxIdScreenState extends State<OnboardingTaxIdScreen> {
  final IvoryTextFieldController _taxIdController = IvoryTextFieldController(text: '489 543 712 07');
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _taxIdController.addListener(() {
      setState(() {
        isValidTaxId(_taxIdController.text);
      });
    });
    ;
  }

  isValidTaxId(String text) {
    text = text.replaceAll(' ', '');
    text.length >= 11 ? _continueButtonController.setEnabled() : _continueButtonController.setDisabled();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 2, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tax ID', style: ClientConfig.getTextStyleScheme().heading2)),
                  const SizedBox(height: 16),
                  IvoryTextField(
                    label: 'Tax ID number',
                    controller: _taxIdController,
                    inputFormatters: [InputFormatter.taxId(_taxIdController.text)],
                    inputType: TextFieldInputType.number,
                    keyboardType: TextInputType.number,
                  ),
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
                                  log('Continue button pressed');
                                  if (isValidTaxId(_taxIdController.text)) {
                                    Navigator.pushNamed(context, WelcomeScreen.routeName);
                                  } else {
                                    _taxIdController
                                        .setErrorText('This Tax ID is invalid for Germany. Please try another.');
                                  }
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
}
