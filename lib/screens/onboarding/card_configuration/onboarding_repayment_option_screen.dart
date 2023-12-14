import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/change_repayment_rate.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingRepaymentOptionScreen extends StatefulWidget {
  static const routeName = "/onboardingRepaymentOptionScreen";

  const OnboardingRepaymentOptionScreen({super.key});

  @override
  State<OnboardingRepaymentOptionScreen> createState() => _OnboardingRepaymentOptionScreenState();
}

class _OnboardingRepaymentOptionScreenState extends State<OnboardingRepaymentOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
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
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Text(
              "Choose the repayment option that suits you",
              style: ClientConfig.getTextStyleScheme().heading2,
            ),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Column(
              children: [
                Text(
                  'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Container(
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
          ),
          const SizedBox(
            height: 16,
          ),
          const OnboardingRepaymentOptionPageContent(),
          const Spacer(),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: PrimaryButton(
              text: "Order my card",
              onPressed: () {},
              // isLoading: viewModel.isLoading,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingRepaymentOptionPageContent extends StatefulWidget {
  // final CardApplicationFetchedViewModel viewModel;

  const OnboardingRepaymentOptionPageContent({
    super.key,
    // required this.viewModel,
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
      // widget.acceptToContinue(canContinue);
    });
  }

  @override
  void initState() {
    super.initState();

    // minFixedRate = (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.05;
    // maxFixedRate = (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.9;
    // inputFixedRateController.text =
    //     (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmount.value / 100) < minFixedRate
    //         ? minFixedRate.toStringAsFixed(2)
    //         : (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmount.value / 100).toStringAsFixed(2);
    // initialPercentageRate = widget.viewModel.cardApplication!.repaymentOptions!.minimumPercentage;

    // if (initialPercentageRate >= 10) {
    //   thumbPercentage = initialPercentageRate;
    // }

    // inputFixedRateController.addListener(() {
    //   if (double.parse(inputFixedRateController.text) >= minFixedRate &&
    //       double.parse(inputFixedRateController.text) <= maxFixedRate) {
    //     setState(() {
    //       canContinue = true;
    //       widget.acceptToContinue(canContinue);
    //     });
    //   } else {
    //     setState(() {
    //       canContinue = false;
    //       widget.acceptToContinue(canContinue);
    //     });
    //   }

    //   if (double.parse(inputFixedRateController.text) < minFixedRate && chosenPercentageRate < 10) {
    //     chosenFixedRate = minFixedRate;
    //   } else if (double.parse(inputFixedRateController.text) >= minFixedRate && chosenPercentageRate < 10) {
    //     chosenFixedRate = double.parse(inputFixedRateController.text);
    //   } else if (double.parse(inputFixedRateController.text) >= minFixedRate && chosenPercentageRate >= 10) {
    //     chosenFixedRate = double.parse(inputFixedRateController.text);
    //     chosenPercentageRate = 3;
    //   } else {
    //     chosenFixedRate = 49;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    const minPercentageRate = 10;
    const maxPercentageRate = 50;

    return Column(
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
        // SizedBox(
        //   width: double.infinity,
        //   height: 48,
        //   child: Button(
        //     text: "Save changes",
        //     disabledColor: ClientConfig.getCustomColors().neutral300,
        //     color: ClientConfig.getColorScheme().tertiary,
        //     textColor: ClientConfig.getColorScheme().surface,
        //     onPressed: canContinue
        //         ? () {
        //             if (chosenPercentageRate >= 10) {
        //               chosenFixedRate = 49;
        //             } else {
        //               chosenPercentageRate = 3;
        //             }

        //             StoreProvider.of<AppState>(context).dispatch(
        //               UpdateCardApplicationCommandAction(
        //                 fixedRate: chosenFixedRate,
        //                 percentageRate: chosenPercentageRate,
        //                 id: widget.viewModel.cardApplication!.id,
        //               ),
        //             );

        //             Navigator.pushNamed(context, RepaymentSuccessfullyChangedScreen.routeName,
        //                 arguments: RepaymentSuccessfullyScreenParams(
        //                   fixedRate: chosenFixedRate,
        //                   interestRate: chosenPercentageRate,
        //                 ));
        //           }
        //         : null,
        //   ),
        // ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class ChooseRepaymentType extends StatefulWidget {
  final RepaymentType repaymentType;
  final double minFixedRate;
  final double maxFixedRate;
  final int minPercentageRate;
  final int maxPercentageRate;
  final int thumbPercentageRate;
  final void Function(int value, int minValue, int maxValue) onPercentageRateChanged;
  final TextEditingController inputFixedRateController;

  const ChooseRepaymentType({
    super.key,
    required this.repaymentType,
    required this.minFixedRate,
    required this.maxFixedRate,
    required this.minPercentageRate,
    required this.maxPercentageRate,
    required this.thumbPercentageRate,
    required this.onPercentageRateChanged,
    required this.inputFixedRateController,
  });

  @override
  State<ChooseRepaymentType> createState() => _ChooseRepaymentTypeState();
}

class _ChooseRepaymentTypeState extends State<ChooseRepaymentType> {
  late RepaymentType selectedRepaymentType;

  @override
  void initState() {
    super.initState();

    selectedRepaymentType = widget.repaymentType;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _showRepaymentTypeContent(type: RepaymentType.percentage),
          const SizedBox(height: 16),
          _showRepaymentTypeContent(type: RepaymentType.fixed),
        ],
      ),
    );
  }

  Widget _showRepaymentTypeContent({required RepaymentType type}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: selectedRepaymentType == type
                ? ClientConfig.getColorScheme().secondary
                : ClientConfig.getCustomColors().neutral200,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => selectedRepaymentType = type),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  activeColor: ClientConfig.getColorScheme().secondary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  value: type,
                  groupValue: selectedRepaymentType,
                  onChanged: (RepaymentType? value) {
                    setState(() {
                      selectedRepaymentType = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    type == RepaymentType.percentage ? 'Percentage rate repayment' : 'Fixed rate repayment',
                    style: ClientConfig.getTextStyleScheme().labelMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 16),
                InkWell(
                  child: SvgPicture.asset(
                    "assets/icons/info.svg",
                    width: 24,
                    height: 24,
                  ),
                  onTap: () {
                    final titleOfModal =
                        type == RepaymentType.percentage ? 'Percentage rate repayment' : 'Fixed rate repayment';
                    final messageOfModal = type == RepaymentType.percentage
                        ? 'Reflects the overall cost of repaying credit, accounting for interest and fees. It allows for transparency and informed financial decisions.'
                        : 'Ensures stability by keeping the interest rate constant throughout the loan term. It provides predictability.';
                    showBottomModal(
                      context: context,
                      title: titleOfModal,
                      textWidget: Text(
                        messageOfModal,
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          if (type == RepaymentType.percentage && type == selectedRepaymentType) ...[
            PercentageRepayment(
                minPercentageRate: widget.minPercentageRate,
                maxPercentageRate: widget.maxPercentageRate,
                thumbPercentageValue: widget.thumbPercentageRate,
                onChanged: (value) =>
                    widget.onPercentageRateChanged(value, widget.minPercentageRate, widget.maxPercentageRate)),
          ],
          if (type == RepaymentType.fixed && type == selectedRepaymentType) ...[
            FixedRepayment(
              minFixedRate: widget.minFixedRate,
              maxFixedRate: widget.maxFixedRate,
              controller: widget.inputFixedRateController,
            ),
          ]
        ],
      ),
    );
  }
}
