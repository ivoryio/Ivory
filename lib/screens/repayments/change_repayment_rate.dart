import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_presenter.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/utilities/format.dart';

import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../models/user.dart';
import '../../redux/app_state.dart';

class ChangeRepaymentRateScreen extends StatefulWidget {
  static const routeName = "/changeRepaymentRateScreen";

  const ChangeRepaymentRateScreen({super.key});

  @override
  State<ChangeRepaymentRateScreen> createState() => _ChangeRepaymentRateScreenState();
}

class _ChangeRepaymentRateScreenState extends State<ChangeRepaymentRateScreen> {
  bool canGoBack = false;

  backWithoutSaving() {
    showBottomModal(
      context: context,
      title: "Are you sure you want to discard the changes?",
      textWidget: Text(
        "The changes you made will not be saved.",
        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
      ),
      content: const ShowBottomModalActions(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;

    return ScreenScaffold(
      body: ScrollableScreenContainer(
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
          child: Column(
            children: [
              AppToolbar(
                onBackButtonPressed: () {
                  if (canGoBack) {
                    backWithoutSaving();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Change repayment rate',
                  style: ClientConfig.getTextStyleScheme().heading1,
                ),
              ),
              const SizedBox(height: 16),
              StoreConnector<AppState, CardApplicationViewModel>(
                onInit: (store) => store.dispatch(GetCardApplicationCommandAction(user: user.cognito)),
                converter: (store) => CardApplicationPresenter.presentCardApplication(
                  cardApplicationState: store.state.cardApplicationState,
                ),
                distinct: true,
                builder: (context, viewModel) {
                  if (viewModel is CardApplicationErrorViewModel) {
                    return const Center(child: Text("Error at change repayment rate screen"));
                  }

                  if (viewModel is CardApplicationFetchedViewModel) {
                    return Expanded(
                      child: Column(
                        children: [
                          Text(
                            'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          ),
                          const SizedBox(height: 24),
                          PageContent(
                            viewModel: viewModel,
                            user: user.cognito,
                            acceptToContinue: (value) => {
                              setState(() {
                                canGoBack = value;
                              })
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageContent extends StatefulWidget {
  final CardApplicationFetchedViewModel viewModel;
  final User user;
  final Function(bool value) acceptToContinue;

  const PageContent({
    super.key,
    required this.viewModel,
    required this.user,
    required this.acceptToContinue,
  });

  @override
  State<PageContent> createState() => _PageContentState();
}

class _PageContentState extends State<PageContent> {
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
      widget.acceptToContinue(canContinue);
    });
  }

  @override
  void initState() {
    super.initState();
    minFixedRate = (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.05;
    maxFixedRate = (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmountUpperThreshold.value / 100) * 0.9;
    inputFixedRateController.text =
        (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmount.value / 100) < minFixedRate
            ? minFixedRate.toStringAsFixed(2)
            : (widget.viewModel.cardApplication!.repaymentOptions!.minimumAmount.value / 100).toStringAsFixed(2);
    initialPercentageRate = widget.viewModel.cardApplication!.repaymentOptions!.minimumPercentage;

    inputFixedRateController.addListener(() {
      if (double.parse(inputFixedRateController.text) >= minFixedRate &&
          double.parse(inputFixedRateController.text) <= maxFixedRate) {
        setState(() {
          canContinue = true;
          widget.acceptToContinue(canContinue);
        });
      } else {
        setState(() {
          canContinue = false;
          widget.acceptToContinue(canContinue);
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
            repaymentType: RepaymentType.percentage,
            minFixedRate: minFixedRate,
            maxFixedRate: maxFixedRate,
            minPercentageRate: minPercentageRate,
            maxPercentageRate: maxPercentageRate,
            thumbPercentageRate: thumbPercentage,
            onPercentageRateChanged: onPercentageRateChanged,
            inputFixedRateController: inputFixedRateController,
          ),
          const SizedBox(height: 24),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Button(
              text: "Save changes",
              disabledColor: ClientConfig.getCustomColors().neutral300,
              color: ClientConfig.getColorScheme().tertiary,
              textColor: ClientConfig.getColorScheme().surface,
              onPressed: canContinue
                  ? () {
                      if (chosenPercentageRate >= 10) {
                        chosenFixedRate = 49;
                      } else {
                        chosenPercentageRate = 3;
                      }

                      StoreProvider.of<AppState>(context).dispatch(
                        UpdateCardApplicationCommandAction(
                          user: widget.user,
                          fixedRate: chosenFixedRate,
                          percentageRate: chosenPercentageRate,
                          id: widget.viewModel.cardApplication!.id,
                        ),
                      );

                      Navigator.pushNamed(context, RepaymentSuccessfullyChangedScreen.routeName,
                          arguments: RepaymentSuccessfullyScreenParams(
                            fixedRate: chosenFixedRate,
                            interestRate: chosenPercentageRate,
                          ));
                    }
                  : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
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
  late RepaymentType selectedRepaymentType = RepaymentType.percentage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showRepaymentTypeContent(type: RepaymentType.percentage),
        const SizedBox(height: 16),
        _showRepaymentTypeContent(type: RepaymentType.fixed),
      ],
    );
  }

  Widget _showRepaymentTypeContent({required RepaymentType type}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: selectedRepaymentType == type ? ClientConfig.getColorScheme().secondary : ClientConfig.getCustomColors().neutral200,
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

class PercentageRepayment extends StatefulWidget {
  final int minPercentageRate;
  final int maxPercentageRate;
  final int thumbPercentageValue;
  final void Function(int) onChanged;

  const PercentageRepayment({
    super.key,
    required this.minPercentageRate,
    required this.maxPercentageRate,
    required this.thumbPercentageValue,
    required this.onChanged,
  });

  @override
  State<PercentageRepayment> createState() => _PercentageRepaymentState();
}

class _PercentageRepaymentState extends State<PercentageRepayment> {
  late int sliderValue;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.thumbPercentageValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                  children: [
                    const TextSpan(
                      text: 'Choose your preferred percentage rate. The ',
                    ),
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(fontWeight: FontWeight.bold),
                      text: 'minimum is ${widget.minPercentageRate}%',
                    ),
                    const TextSpan(
                      text: ' and the ',
                    ),
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(fontWeight: FontWeight.bold),
                      text: 'maximum is ${widget.maxPercentageRate}%',
                    ),
                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 8,
                trackShape: const RoundedRectSliderTrackShape(),
                activeTrackColor: ClientConfig.getColorScheme().secondary,
                inactiveTrackColor: ClientConfig.getCustomColors().neutral200,
                thumbColor: ClientConfig.getColorScheme().primary,
                thumbShape: CustomThumb(label: sliderValue),
                overlayColor: const Color(0x00FFFF00),
                valueIndicatorColor: ClientConfig.getColorScheme().secondary,
                valueIndicatorTextStyle: ClientConfig.getTextStyleScheme().bodySmallBold,
              ),
              child: Expanded(
                child: Slider(
                  value: sliderValue.toDouble(),
                  onChanged: (double newValue) {
                    setState(() {
                      sliderValue = newValue.toInt();
                    });
                  },
                  onChangeEnd: (double newValue) {
                    setState(() {
                      sliderValue = newValue.toInt();
                    });

                    widget.onChanged(newValue.toInt());
                  },
                  min: widget.minPercentageRate.toDouble(),
                  max: widget.maxPercentageRate.toDouble(),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18),
              child: Text('${widget.minPercentageRate}%'),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text('${widget.maxPercentageRate}%'),
            ),
          ],
        ),
      ],
    );
  }
}

class FixedRepayment extends StatefulWidget {
  final double minFixedRate;
  final double maxFixedRate;
  final TextEditingController controller;

  const FixedRepayment({
    super.key,
    required this.minFixedRate,
    required this.maxFixedRate,
    required this.controller,
  });

  @override
  State<FixedRepayment> createState() => _FixedRepaymentState();
}

class _FixedRepaymentState extends State<FixedRepayment> {
  bool isErrorRange = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final RegExp regExp = RegExp(r'^\d+\.?\d*$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                  children: [
                    const TextSpan(
                      text: 'Choose your preferred fixed rate. The ',
                    ),
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(fontWeight: FontWeight.bold),
                      text: 'minimum is ${Format.currency(widget.minFixedRate)}',
                    ),
                    const TextSpan(
                      text: ' and the ',
                    ),
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(fontWeight: FontWeight.bold),
                      text: 'maximum is ${Format.currency(widget.maxFixedRate)}',
                    ),
                    const TextSpan(
                      text: '.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: isErrorRange ? Colors.red : const Color(0xFFADADB4),
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                color: ClientConfig.getCustomColors().neutral100,
              ),
              child: Text(
                '€',
                style: ClientConfig.getTextStyleScheme().heading2.copyWith(color: const Color(0xFFADADB4)),
              ),
            ),
            Expanded(
              child: TextField(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                autofocus: true,
                controller: widget.controller,
                onChanged: (inputValue) {
                  if (inputValue.isEmpty) inputValue = '0';

                  setState(() {
                    isErrorRange = (double.parse(inputValue) < widget.minFixedRate ||
                        double.parse(inputValue) > widget.maxFixedRate);
                  });

                  if (double.parse(inputValue) < widget.minFixedRate) {
                    errorMessage = 'Rate is too low. The minimum is € ${widget.minFixedRate}.';
                  }

                  if (double.parse(inputValue) > widget.maxFixedRate) {
                    errorMessage = 'Rate is too high. The maximum is € ${widget.maxFixedRate}.';
                  }
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(regExp),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      final inputValue = newValue.text;

                      if (inputValue.isEmpty) {
                        return newValue.copyWith(text: '');
                      }

                      return (inputValue.contains(regExp)) ? newValue : oldValue;
                    },
                  ),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: ClientConfig.getCustomColors().neutral100,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: isErrorRange ? Colors.red : const Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: isErrorRange ? Colors.red : const Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        isErrorRange
            ? Text(
                errorMessage,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.red,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class CustomThumb extends SliderComponentShape {
  final int label;

  CustomThumb({required this.label});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size.fromRadius(20);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    double? value,
    double? textScaleFactor,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    Size? sizeWithOverflow,
    TextDirection? textDirection,
    bool isPressed = false,
  }) {
    final canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme!.thumbColor!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, paint);

    final textSpan = TextSpan(
      text: '${label.round()}%',
      style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: Colors.white),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final textOffset = Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);

    textPainter.paint(canvas, textOffset);
  }
}

class ShowBottomModalActions extends StatelessWidget {
  const ShowBottomModalActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenVerticalPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          CustomAction(
            path: () {
              Navigator.pop(context);
            },
            message: 'No, go back',
            backgroundColor: Colors.white,
            borderColor: Colors.black,
            messageColor: Colors.black,
          ),
          const SizedBox(height: 16),
          CustomAction(
            path: () {
              Navigator.popUntil(context, ModalRoute.withName(RepaymentsScreen.routeName));
            },
            message: 'Yes, discard changes',
            backgroundColor: Colors.red,
            borderColor: Colors.red,
            messageColor: Colors.white,
          ),
        ],
      ),
    );
  }
}

class CustomAction extends StatelessWidget {
  final void Function() path;
  final String message;
  final Color backgroundColor;
  final Color borderColor;
  final Color messageColor;

  const CustomAction({
    super.key,
    required this.path,
    required this.message,
    required this.backgroundColor,
    required this.borderColor,
    required this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () => path(),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            side: BorderSide(
              width: 1,
              color: borderColor,
              style: BorderStyle.solid,
            ),
          ),
          elevation: 0,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: messageColor,
          ),
        ),
      ),
    );
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
