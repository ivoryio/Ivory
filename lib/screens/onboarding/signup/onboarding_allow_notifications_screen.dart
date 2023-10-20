import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_signup_presenter.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_allow_notifications_success_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingAllowNotificationsScreen extends StatelessWidget {
  static const routeName = '/onboardingAllowNotificationsScreen';

  const OnboardingAllowNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingSignupViewModel>(
      converter: (store) => OnboardingSignupPresenter.presentSignup(state: store.state.onboardingSignupState),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel is OnboardingSignupNotificationsAllowedViewModel &&
            _routeNotInStack(OnboardingAllowNotificationsSuccessScreen.routeName)) {
          Navigator.pushNamed(context, OnboardingAllowNotificationsSuccessScreen.routeName);
        }
      },
      builder: (context, vm) => ScreenScaffold(
        body: Column(
          children: [
            AppToolbar(
              richTextTitle: StepRichTextTitle(step: 4, totalSteps: 5),
              actions: const [AppbarLogo()],
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            AnimatedLinearProgressIndicator.step(current: 4, totalSteps: 5),
            Expanded(
              child: ScrollableScreenContainer(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "Instant notifications on all account activity",
                      style: ClientConfig.getTextStyleScheme().heading2,
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          _BodyText(text: "We send "),
                          _BoldText(text: "push notifications for every transaction and account activity "),
                          _BodyText(
                            text:
                                ", providing you with real-time updates. You'll also receive notifications during onboarding once ",
                          ),
                          _BoldText(text: "your identity and score are verified"),
                          _BodyText(text: "."),
                        ],
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: SvgPicture(
                          SvgAssetLoader(
                            'assets/images/notifications_illustration.svg',
                            colorMapper: IvoryColorMapper(
                              baseColor: ClientConfig.getColorScheme().secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SecondaryButton(
                      text: "Not right now",
                      borderWidth: 2,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: "Allow notifications",
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(RequestPushNotificationsPermissionCommandAction());
                      },
                    ),
                    const SizedBox(height: 16)
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

bool _routeNotInStack(String routeName) {
  return !IvoryApp.generalRouteObserver.isRouteInStack(routeName);
}

class _BodyText extends TextSpan {
  _BodyText({required String text})
      : super(
          text: text,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
        );
}

class _BoldText extends TextSpan {
  _BoldText({required String text})
      : super(
          text: text,
          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
        );
}
