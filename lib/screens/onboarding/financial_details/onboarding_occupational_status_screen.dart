import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/onboarding/onboarding_financial_details_attributes.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
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
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _occupationController.addListener(onChange);
  }

  onChange() {
    if (_occupationController.selectedOptions.isEmpty) {
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
            richTextTitle: StepRichTextTitle(step: 4, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 4, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: SizedBox(
                width: double.infinity,
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
                        SelectOption(textLabel: 'Freelancer', value: OnboardingOccupationalStatus.freelancer.name),
                        SelectOption(textLabel: 'Apprentice', value: OnboardingOccupationalStatus.apprentice.name),
                        SelectOption(textLabel: 'Retired', value: OnboardingOccupationalStatus.retired.name),
                        SelectOption(textLabel: 'Student', value: OnboardingOccupationalStatus.student.name),
                      ],
                    ),
                    ListenableBuilder(
                      listenable: _occupationController,
                      builder: (context, child) {
                        final selectedOccupation = _occupationController.selectedOptions.firstOrNull?.value;

                        if (selectedOccupation == 'employed') {
                          return Text('EMPLOY');
                        }

                        if (selectedOccupation == 'freelancer') {
                          return Text('UNEMPLOY');
                        }

                        return const SizedBox();
                      },
                    ),
                    const Spacer(),
                    PrimaryButton(
                        text: "Continue",
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled ? () {} : null),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
