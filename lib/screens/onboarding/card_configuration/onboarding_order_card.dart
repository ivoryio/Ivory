import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/screens/onboarding/card_configuration/onboarding_configure_card.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/card_widget.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/skeleton.dart';

import '../../../config.dart';
import '../../../infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import '../../../models/bank_card.dart';
import '../../../redux/app_state.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import '../../../widgets/animated_linear_progress_indicator.dart';
import '../../../widgets/app_toolbar.dart';

class OnboardingOrderCardScreen extends StatefulWidget {
  static const routeName = "/onboardingOrderCardScreen";

  const OnboardingOrderCardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingOrderCardScreen> createState() => _OnboardingOrderCardScreenState();
}

class _OnboardingOrderCardScreenState extends State<OnboardingOrderCardScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 3),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 3),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Text(
              "Order your Ivory credit card",
              style: ClientConfig.getTextStyleScheme().heading2,
            ),
          ),
          StoreConnector<AppState, OnboardingCardConfigurationViewModel>(
            onInit: (store) {
              store.dispatch(GetCardPersonNameCommandAction());
            },
            onDidChange: (oldViewModel, newViewModel) {
              if (newViewModel is OnboardingCardConfigurationGenericSuccessViewModel &&
                  ModalRoute.of(context)?.isCurrent == true) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(OnboardingConfigureCardScreen.routeName, (route) => false);
              }
            },
            converter: (store) => OnboardingCardConfigurationPresenter.presentCardConfiguration(
              cardConfigurationState: store.state.onboardingCardConfigurationState,
            ),
            builder: (context, viewModel) {
              return _buildFrom(viewModel, context);
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildFrom(OnboardingCardConfigurationViewModel viewModel, BuildContext context) {
  if (viewModel is WithCardholderNameViewModel) {
    return Expanded(
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: Column(
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: "You should receive it at your residential address in",
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
                TextSpan(
                  text: " 2-5 working days. ",
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                TextSpan(
                  text:
                      "You’ll have to activate it in the app once it arrives. Then you'll be ready to start using it.",
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
              ]),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BankCardWidget(
                cardType: BankCardType.VISA_CREDIT,
                cardNumber: "****************",
                cardHolder: viewModel.cardholderName,
                cardExpiry: "MM/YY",
                customHeight: 188,
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: "Order my card",
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(OnboardingCreateCardCommandAction());
              },
              isLoading: viewModel.isLoading,
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: ClientConfig.getCustomColors().neutral100.withOpacity(.15),
        ),
        child: SkeletonContainer(
          colorTheme: SkeletonColorTheme.dark,
          child: Skeleton(
            width: 343,
            height: 202,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 64, height: 24, transparent: true),
                      Skeleton(width: 64, height: 24, transparent: true),
                    ],
                  ),
                  SizedBox(height: 33),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 48, height: 24, transparent: true),
                      Skeleton(width: 48, height: 24, transparent: true),
                      Skeleton(width: 48, height: 24, transparent: true),
                      Skeleton(width: 48, height: 24, transparent: true),
                    ],
                  ),
                  SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 64, height: 10, transparent: true),
                      Skeleton(width: 64, height: 10, transparent: true),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Skeleton(width: 88, height: 16, transparent: true),
                      Skeleton(width: 88, height: 16, transparent: true),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  return Expanded(
    child: Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Column(
        children: [
          Text(
            'Please bear with us a couple of seconds while we create your card...',
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
          const Spacer(),
          _buildLoadingSkeleton(),
          const Spacer(),
          const PrimaryButton(text: "Order my card"),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    ),
  );
}
