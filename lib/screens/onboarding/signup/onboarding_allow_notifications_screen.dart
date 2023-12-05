import 'package:app_settings/app_settings.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/signup/onboarding_signup_presenter.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_term_conditions_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingAllowNotificationsScreen extends StatefulWidget {
  static const routeName = '/onboardingAllowNotificationsScreen';

  const OnboardingAllowNotificationsScreen({super.key});

  @override
  State<OnboardingAllowNotificationsScreen> createState() => _OnboardingAllowNotificationsScreenState();
}

class _OnboardingAllowNotificationsScreenState extends State<OnboardingAllowNotificationsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final currentRoute = IvoryApp.generalRouteObserver.routeStack.lastOrNull;

    if (state == AppLifecycleState.resumed && currentRoute == OnboardingAllowNotificationsScreen.routeName) {
      StoreProvider.of<AppState>(context).dispatch(CheckPushNotificationPermissionCommandAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingSignupViewModel>(
      converter: (store) => OnboardingSignupPresenter.present(signupState: store.state.onboardingSignupState),
      builder: (context, viewModel) => ScreenScaffold(
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
                child: viewModel.signupAttributes.notificationsAllowed == true
                    ? const _AllowedPermissionContent()
                    : _RequestNotificationPermissionContent(viewModel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestNotificationPermissionContent extends StatelessWidget {
  final OnboardingSignupViewModel viewModel;

  const _RequestNotificationPermissionContent(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              const TextSpan(text: "We send "),
              TextSpan(
                text: "push notifications for every transaction and account activity ",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
              ),
              const TextSpan(
                text:
                    ", providing you with real-time updates. You'll also receive notifications during onboarding once ",
              ),
              TextSpan(
                text: "your identity and score are verified",
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
              ),
              const TextSpan(text: "."),
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
          onPressed: () {
            Navigator.pushNamed(context, OnboardingTermConditionsScreen.routeName);
          },
        ),
        const SizedBox(height: 16),
        viewModel.signupAttributes.notificationsAllowed == false
            ? PrimaryButton(
                text: "Go to notification settings",
                onPressed: () async {
                  await AppSettings.openAppSettings(type: AppSettingsType.notification);
                },
              )
            : PrimaryButton(
                text: "Allow notifications",
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(RequestPushNotificationsPermissionCommandAction());
                },
              ),
        const SizedBox(height: 16)
      ],
    );
  }
}

class _AllowedPermissionContent extends StatelessWidget {
  const _AllowedPermissionContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Instant notifications on all account activity",
          style: ClientConfig.getTextStyleScheme().heading2,
        ),
        const SizedBox(height: 16),
        Text("Thank you! We will notify you about every account acitivity.",
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
        Expanded(
          child: IvoryAssetWithBadge(
            isSuccess: true,
            childPosition: BadgePosition.topStart(start: -5, top: -30),
            childWidget: SvgPicture(
              SvgAssetLoader(
                'assets/images/notifications_illustration.svg',
                colorMapper: IvoryColorMapper(
                  baseColor: ClientConfig.getColorScheme().secondary,
                ),
              ),
            ),
          ),
        ),
        PrimaryButton(
          text: "Continue",
          onPressed: () {
            Navigator.pushNamed(context, OnboardingTermConditionsScreen.routeName);
          },
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
