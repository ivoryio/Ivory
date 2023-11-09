import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_select_option.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingOccupationalStatusScreen extends StatelessWidget {
  static const routeName = '/onboardingOccupationalStatusScreen';

  const OnboardingOccupationalStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final IvorySelectOptionController occupationController = IvorySelectOptionController();

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
                    controller: occupationController,
                    options: [
                      SelectOption(textLabel: 'Employed', value: 'employed'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
