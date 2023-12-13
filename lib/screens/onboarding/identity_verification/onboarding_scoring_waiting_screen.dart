import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_credit_limit_congratulations_screen.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_scoring_rejected_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingScoringWaitingScreen extends StatelessWidget {
  static const routeName = "/onboardingScoringWaitingScreen";

  const OnboardingScoringWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: store.state.onboardingIdentityVerificationState,
        notificationState: store.state.notificationState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isScoringSuccessful == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, OnboardingCreditLimitCongratulationsScreen.routeName, (route) => false);
        } else if (newViewModel.isScoringSuccessful == false) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingScoringRejectedScreen.routeName, (route) => false);
        }
      },
      distinct: true,
      builder: (context, viewModel) => ScreenScaffold(
        body: Column(
          children: [
            AppToolbar(
              richTextTitle: StepRichTextTitle(step: 6, totalSteps: 7),
              actions: const [AppbarLogo()],
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            AnimatedLinearProgressIndicator.step(current: 6, totalSteps: 7),
            const SizedBox(height: 16),
            Expanded(
              child: ScrollableScreenContainer(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scoring in progress...',
                      style: ClientConfig.getTextStyleScheme().heading2,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "It can take up to 5 minutes for your score to be processed. \n\nWe will notify you when your score is available.",
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                    Expanded(
                      child: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/waiting_illustration.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
