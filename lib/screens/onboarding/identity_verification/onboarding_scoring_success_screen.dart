import 'package:flutter/cupertino.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingScoringSuccessScreen extends StatelessWidget {
  static const routeName = "/onboardingScoringSuccessScreen";

  const OnboardingScoringSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 7, totalSteps: 7),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(current: 7, totalSteps: 7, isCompleted: true),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Congratulations!',
                    style: ClientConfig.getTextStyleScheme().heading2,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "We're thrilled to inform you that your credit score has been approved and we're delighted to offer you the following credit limit:",
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: Container()),
                  PrimaryButton(
                    text: "Continue",
                    onPressed: () {},
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
