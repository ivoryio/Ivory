import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_progress_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingCongratulationsScreen extends StatelessWidget {
  static const routeName = "/onboardingCongratulationsScreen";

  const OnboardingCongratulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: ScrollableScreenContainer(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: StoreConnector<AppState, OnboardingProgressViewModel>(
          converter: (store) => OnboardingProgressPresenter.presentOnboardingProgress(
            onboardingProgressState: store.state.onboardingProgressState,
            authState: store.state.authState,
          ),
          onWillChange: (previousViewModel, newViewModel) {
            if (newViewModel is RedirectToHomeViewModel) {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false);
            } else if (newViewModel is OnboardingProgressErrorViewModel) {
              _showServerErrorBottomSheet(context);
            }
          },
          distinct: true,
          builder: (context, viewModel) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppToolbar(),
              const ScreenTitle("Congratulations!"),
              const SizedBox(height: 16),
              Text(
                "Your credit card is ready! After you receive it at your address, you will be able to activate it, set your PIN and start using it. \n\nLet's get you to the app now.",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SvgPicture(
                  SvgAssetLoader(
                    'assets/images/congratulations_illustration.svg',
                    colorMapper: IvoryColorMapper(
                      baseColor: ClientConfig.getColorScheme().secondary,
                    ),
                  ),
                ),
              ),
              PrimaryButton(
                text: "Go to the app",
                isLoading: viewModel is OnboardingProgressLoadingViewModel,
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(FinalizeOnboardingCommandAction());
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showServerErrorBottomSheet(BuildContext context) {
    showBottomModal(
      context: context,
      showCloseButton: false,
      isDismissible: false,
      title: 'Server error',
      textWidget: RichText(
        text: TextSpan(style: ClientConfig.getTextStyleScheme().bodyLargeRegular, children: [
          const TextSpan(
            text:
                'We encountered an unexpected technical error. Please try again. If the issue persists, please contact our support team at ',
          ),
          TextSpan(
              text: "+49 (0)123 456789",
              style: ClientConfig.getTextStyleScheme()
                  .bodyLargeRegularBold
                  .copyWith(color: ClientConfig.getColorScheme().secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final telUri = Uri(
                    scheme: 'tel',
                    path: '+490123456789',
                  );

                  if (await canLaunchUrl(telUri)) {
                    await launchUrl(telUri);
                  }
                }),
          const TextSpan(text: '.')
        ]),
      ),
      content: Column(
        children: [
          const SizedBox(height: 24),
          PrimaryButton(
            text: "Try again",
            onPressed: () {
              Navigator.pop(context);
              StoreProvider.of<AppState>(context).dispatch(FinalizeOnboardingCommandAction());
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
