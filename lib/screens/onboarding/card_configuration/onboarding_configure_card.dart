import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/screens/onboarding/card_configuration/onboarding_repayment_option_screen.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import '../../../models/bank_card.dart';
import '../../../redux/app_state.dart';
import '../../../redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import '../../../widgets/animated_linear_progress_indicator.dart';
import '../../../widgets/app_toolbar.dart';
import '../../../widgets/button.dart';
import '../../../widgets/card_widget.dart';
import '../../../widgets/circular_loading_indicator.dart';

class OnboardingConfigureCardScreen extends StatefulWidget {
  static const routeName = "/onboardingConfigureCardScreen";

  const OnboardingConfigureCardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingConfigureCardScreen> createState() => _OnboardingConfigureCardScreenState();
}

class _OnboardingConfigureCardScreenState extends State<OnboardingConfigureCardScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppToolbar(
              richTextTitle: StepRichTextTitle(step: 2, totalSteps: 3),
              actions: const [AppbarLogo()],
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 3),
            const SizedBox(height: 16,),
            Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Text(
                "Credit card ordered",
                style: ClientConfig.getTextStyleScheme().heading2,
              ),
            ),
            Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Text.rich(
                TextSpan(
                    children: [
                      TextSpan(
                        text: "Now ",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                      TextSpan(
                        text: "let’s begin the configuration process ",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                      ),
                      TextSpan(
                        text: "and tailor your card to fit your lifestyle and financial needs.",
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    ],),
              ),
            ),
            StoreConnector<AppState, OnboardingCardConfigurationViewModel>(
              onInit: (store) {
                store.dispatch(GetOnboardingCardInfoCommandAction());
              },
            onWillChange: (oldViewModel, newViewModel) {
              if (oldViewModel is WithCardInfoViewModel &&
                  oldViewModel.isLoading &&
                  newViewModel is OnboardingCreditCardApplicationFetchedViewModel) {
                Navigator.of(context).pushNamed(
                  OnboardingRepaymentOptionScreen.routeName,
                );
              }
              },
              converter: (store) => OnboardingCardConfigurationPresenter.presentCardConfiguration(
                cardConfigurationState: store.state.onboardingCardConfigurationState,
              ),
              builder: (context, viewModel) {
                return _buildFrom(viewModel);
              },
            ),
          ],),
    );
  }

  Widget _buildFrom(OnboardingCardConfigurationViewModel viewModel) {
    if(viewModel is WithCardInfoViewModel) {
      return Expanded(
        child: Padding(
          padding: ClientConfig
              .getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
          child: Column(
            children: [
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IvoryAssetWithBadge(
                  childWidget: BankCardWidget(
                    cardType: BankCardType.VISA_CREDIT,
                    cardNumber: viewModel.maskedPAN,
                    cardHolder: viewModel.cardholderName,
                    cardExpiry: viewModel.expiryDate,
                    customHeight: 188,
                  ),
                  isSuccess: true,
                  childPosition: BadgePosition.topStart(top: -35, start: 130),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: "Configure my card",
                isLoading: viewModel.isLoading,
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                    OnboardingGetCreditCardApplicationCommandAction(),
                  );
                },
              ),
              const SizedBox(height: 16,),
            ],
          ),
        ),
      );
    }

    return Expanded(
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          child: const Column(
            children: [
              Spacer(),
              CircularLoadingIndicator(),
              Spacer(),
              PrimaryButton(text: "Configure my card"),
              SizedBox(height: 16,),
            ],
          ),
        ),
    );
  }
}
