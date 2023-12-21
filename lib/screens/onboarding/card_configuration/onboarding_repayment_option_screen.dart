import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/card_configuration/onboarding_card_configuration_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/card_configuration/onboarding_card_configuration_action.dart';
import 'package:solarisdemo/screens/onboarding/card_configuration/onboarding_congratulations_screen.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingRepaymentOptionScreen extends StatefulWidget {
  static const routeName = "/onboardingRepaymentOptionScreen";

  const OnboardingRepaymentOptionScreen({super.key});

  @override
  State<OnboardingRepaymentOptionScreen> createState() => _OnboardingRepaymentOptionScreenState();
}

class _OnboardingRepaymentOptionScreenState extends State<OnboardingRepaymentOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingCardConfigurationViewModel>(
      onWillChange: (previousViewModel, newViewModel) {
        if (previousViewModel is OnboardingCreditCardApplicationFetchedViewModel &&
            previousViewModel.isLoading == true &&
            newViewModel is OnboardingCreditCardApplicationUpdatedViewModel) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingCongratulationsScreen.routeName, (_) => false);
        }
      },
      converter: (store) => OnboardingCardConfigurationPresenter.presentCardConfiguration(
        cardConfigurationState: store.state.onboardingCardConfigurationState,
      ),
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToolbar(
                backButtonEnabled: false,
                richTextTitle: StepRichTextTitle(step: 3, totalSteps: 3),
                actions: const [AppbarLogo()],
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              AnimatedLinearProgressIndicator.step(
                current: 3,
                totalSteps: 3,
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    children: [
                      Text(
                        "Choose the repayment option that suits you",
                        style: ClientConfig.getTextStyleScheme().heading2,
                      ),
                      Column(
                        children: [
                          Text(
                            'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: ClientConfig.getCustomColors().neutral200),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: ClientConfig.getCustomColors().neutral100,
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              const Icon(Icons.info_outline),
                              const SizedBox(width: 8),
                              Text(
                                '5% interest rate',
                                style: ClientConfig.getTextStyleScheme().heading4,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Our fixed interest rate of 5% remains the same, no matter the repayment type or rate you select. It will accrue based on your outstanding balance after the repayment has been deducted.',
                            style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                          ),
                        ]),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (viewModel is OnboardingCreditCardApplicationFetchedViewModel)
                        OnboardingRepaymentOptionPageContent(
                          viewModel: viewModel,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingRepaymentOptionPageContent extends StatefulWidget {
  final OnboardingCreditCardApplicationFetchedViewModel viewModel;

  const OnboardingRepaymentOptionPageContent({
    super.key,
    required this.viewModel,
  });

  @override
  State<OnboardingRepaymentOptionPageContent> createState() => _OnboardingRepaymentOptionPageContentState();
}

class _OnboardingRepaymentOptionPageContentState extends State<OnboardingRepaymentOptionPageContent> {
  final TextEditingController inputFixedRateController = TextEditingController();
  int initialPercentageRate = 0;
  int thumbPercentage = 20;
  double minFixedRate = 0;
  double maxFixedRate = 0;
  int chosenPercentageRate = 3;
  double chosenFixedRate = 49;

  bool canContinue = false;

  void onPercentageRateChanged(int value, int minValue, int maxValue) {
    setState(() {
      chosenPercentageRate = value;
      canContinue = value >= 10;
    });
  }

  @override
  void initState() {
    super.initState();

    minFixedRate = (widget.viewModel.cardApplication.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.05;
    maxFixedRate = (widget.viewModel.cardApplication.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.9;
    inputFixedRateController.text =
        (widget.viewModel.cardApplication.repaymentOptions!.minimumAmount.value / 100) < minFixedRate
            ? minFixedRate.toStringAsFixed(2)
            : (widget.viewModel.cardApplication.repaymentOptions!.minimumAmount.value / 100).toStringAsFixed(2);
    initialPercentageRate = widget.viewModel.cardApplication.repaymentOptions!.minimumPercentage;

    if (initialPercentageRate >= 10) {
      thumbPercentage = initialPercentageRate;
    }

    inputFixedRateController.addListener(() {
      if (inputFixedRateController.text.isNotEmpty) {
        if (double.parse(inputFixedRateController.text) >= minFixedRate &&
            double.parse(inputFixedRateController.text) <= maxFixedRate) {
          setState(() {
            canContinue = true;
          });
        } else {
          setState(() {
            canContinue = false;
          });
        }

        if (double.parse(inputFixedRateController.text) < minFixedRate && chosenPercentageRate < 10) {
          chosenFixedRate = minFixedRate;
        } else if (double.parse(inputFixedRateController.text) >= minFixedRate && chosenPercentageRate < 10) {
          chosenFixedRate = double.parse(inputFixedRateController.text);
        } else if (double.parse(inputFixedRateController.text) >= minFixedRate && chosenPercentageRate >= 10) {
          chosenFixedRate = double.parse(inputFixedRateController.text);
          chosenPercentageRate = 3;
        } else {
          chosenFixedRate = 49;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const minPercentageRate = 10;
    const maxPercentageRate = 50;

    return Expanded(
      child: Column(
        children: [
          ChooseRepaymentType(
            repaymentType: (initialPercentageRate >= 10) ? RepaymentType.percentage : RepaymentType.fixed,
            minFixedRate: minFixedRate,
            maxFixedRate: maxFixedRate,
            minPercentageRate: minPercentageRate,
            maxPercentageRate: maxPercentageRate,
            thumbPercentageRate: thumbPercentage,
            onPercentageRateChanged: onPercentageRateChanged,
            inputFixedRateController: inputFixedRateController,
          ),
          const Spacer(),
          PrimaryButton(
            isLoading: widget.viewModel.isLoading,
            text: "Confirm & finish",
            onPressed: canContinue
                ? () {
                    if (chosenPercentageRate >= 10) {
                      chosenFixedRate = 49;
                    } else {
                      chosenPercentageRate = 3;
                    }

                    StoreProvider.of<AppState>(context).dispatch(
                      OnboardingUpdateCreditCardApplicationCommandAction(
                        fixedRate: chosenFixedRate,
                        percentageRate: chosenPercentageRate,
                        id: widget.viewModel.cardApplication.id,
                      ),
                    );
                  }
                : null,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
