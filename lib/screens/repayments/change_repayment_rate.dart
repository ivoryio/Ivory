import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/repayments/change_repayment/change_repayment_presenter.dart';
import 'package:solarisdemo/redux/repayments/change_repayment/change_repayment_action.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/utilities/format.dart';

import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../redux/app_state.dart';

class ChangeRepaymentRateScreen extends StatelessWidget {
  static const routeName = "/changeRepaymentRateScreen";

  const ChangeRepaymentRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;
    bool _canContinue = false;

    backWithoutSaving() {
      showBottomModal(
        context: context,
        title: "Are you sure you want to discard the changes?",
        message: "The changes you made will not be saved.",
        content: const ShowBottomModalActions(),
      );
    }

    // final CreditLineState creditLineState = StoreProvider.of<AppState>(context).state.creditLineState;

    // if (creditLineState is CreditLineFetchedState) {
    //   _initialFixedRepayment.text = creditLineState.creditLine.fixedRate.value.toString();
    // }

    return ScreenScaffold(
      body: ScrollableScreenContainer(
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
          child: Column(
            children: [
              AppToolbar(
                onBackButtonPressed: (_canContinue == true) ? backWithoutSaving : null,
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
                    return const Center(child: Text("Error"));
                  }

                  if (viewModel is CardApplicationFetchedViewModel) {
                    return PageContent(viewModel: viewModel);
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

class PageContent extends StatelessWidget {
  final CardApplicationFetchedViewModel viewModel;

  const PageContent({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    var referenceValue = viewModel.cardApplication!.repaymentOptions!.minimumAmountUpperThreshold.value / 100;
    var lowerAmount = referenceValue * 0.05;
    var upperAmount = referenceValue * 0.9;

    return Expanded(
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
              children: [
                const TextSpan(
                  text:
                      'We provide fixed repayment options with flexibility. You can select your preferred fixed rate, ranging from a minimum of ',
                ),
                TextSpan(
                  text: Format.currency(lowerAmount),
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                const TextSpan(
                  text: ' to a maximum of ',
                ),
                TextSpan(
                  text: Format.currency(upperAmount),
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                ),
                const TextSpan(
                  text: '.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const ChooseRepaymentType(),
          const SizedBox(height: 24),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: Button(
              text: "Save changes",
              disabledColor: const Color(0xFFDFE2E6),
              color: ClientConfig.getColorScheme().tertiary,
              textColor: ClientConfig.getColorScheme().surface,
              // onPressed: _canContinue
              //     ? () {
              //         final valueForRepayment = _initialFixedRepayment.text;

              //         StoreProvider.of<AppState>(context).dispatch(
              //           UpdateCardApplicationCommandAction(
              //             user: user,
              //             fixedRate: double.parse(valueForRepayment),
              //             id: viewModel.cardApplication.id,
              //           ),
              //         );

              //         Navigator.pushNamed(context, RepaymentSuccessfullyChangedScreen.routeName,
              //             arguments: RepaymentSuccessfullyScreenParams(
              //               fixedRate: double.parse(valueForRepayment),
              //               interestRate: 5,
              //             ));
              //       }
              //     : null,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class ShowBottomModalActions extends StatelessWidget {
  const ShowBottomModalActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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

class ChooseRepaymentType extends StatefulWidget {
  final RepaymentType typeOfRepayment;

  const ChooseRepaymentType({
    super.key,
    this.typeOfRepayment = RepaymentType.percentage,
  });

  @override
  State<ChooseRepaymentType> createState() => _ChooseRepaymentTypeState();
}

class _ChooseRepaymentTypeState extends State<ChooseRepaymentType> {
  late RepaymentType selectedRepaymentType;

  @override
  void initState() {
    super.initState();
    selectedRepaymentType = widget.typeOfRepayment;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PercentageRepayment(
          onPercentageValue: (value) => {
            print(value),
          },
        ),
        SizedBox(height: 16),
        FixedRepayment(),
      ],
    );
  }
}

class PercentageRepayment extends StatefulWidget {
  final void Function(double) onPercentageValue;

  const PercentageRepayment({
    super.key,
    required this.onPercentageValue,
  });

  @override
  State<PercentageRepayment> createState() => _PercentageRepaymentState();
}

class _PercentageRepaymentState extends State<PercentageRepayment> {
  @override
  Widget build(BuildContext context) {
    double sliderValue = 25;
    double min = 5;
    double max = 90;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: ClientConfig.getColorScheme().secondary,
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
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
                      TextSpan(
                        text: 'Choose your preferred percentage rate. The ',
                      ),
                      TextSpan(
                        style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(fontWeight: FontWeight.bold),
                        text: 'minimum is 5%',
                      ),
                      TextSpan(
                        text: 'Choose your preferred percentage rate. The minimum is 5% and the maximum is 90%.',
                      ),
                      TextSpan(
                        text: 'Choose your preferred percentage rate. The minimum is 5% and the maximum is 90%.',
                      ),
                      TextSpan(
                        text: 'Choose your preferred percentage rate. The minimum is 5% and the maximum is 90%.',
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
                  inactiveTrackColor: const Color(0xFFE9EAEB),
                  thumbColor: ClientConfig.getColorScheme().primary,
                  thumbShape: CustomThumb(label: sliderValue),
                  overlayColor: const Color(0x00FFFF00),
                  valueIndicatorColor: ClientConfig.getColorScheme().secondary,
                  valueIndicatorTextStyle: ClientConfig.getTextStyleScheme().bodySmallBold,
                ),
                child: Expanded(
                  child: Slider(
                    value: sliderValue,
                    onChanged: (double newValue) {
                      setState(() {
                        sliderValue = newValue;
                      });
                    },
                    onChangeEnd: (double newValue) {
                      setState(() {
                        sliderValue = newValue;
                      });

                      widget.onPercentageValue(newValue);
                    },
                    min: min,
                    max: max,
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
                child: Text('${min.toInt()}%'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text('${max.toInt()}%'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomThumb extends SliderComponentShape {
  final double label;

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

class FixedRepayment extends StatefulWidget {
  const FixedRepayment({super.key});

  @override
  State<FixedRepayment> createState() => _FixedRepaymentState();
}

class _FixedRepaymentState extends State<FixedRepayment> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  color: const Color(0xFFADADB4),
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                color: const Color(0xFFF8F9FA),
              ),
              child: Text(
                '€',
                style: ClientConfig.getTextStyleScheme().heading2.copyWith(color: const Color(0xFFADADB4)),
              ),
            ),
            Expanded(
              child: TextField(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                // controller: widget.controller,
                onChanged: (text) {
                  if (text.isEmpty) text = '0';

                  // if (widget.onChanged != null) {
                  //   widget.onChanged!(text);
                  // }

                  // setState(() {
                  //   _rangeError = (double.parse(text) < 500 || double.parse(text) > 9000);
                  // });

                  // if (double.parse(text) < 500) {
                  //   errorMessage = 'Rate is too low. The minimum is €500.';
                  // }

                  // if (double.parse(text) > 9000) {
                  //   errorMessage = 'Rate is too high. The maximum is €9,000.';
                  // }
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.allow(regExp),
                //   TextInputFormatter.withFunction(
                //     (oldValue, newValue) {
                //       final text = newValue.text;

                //       if (text.isEmpty) {
                //         return newValue.copyWith(text: '');
                //       }

                //       return (text.contains(regExp)) ? newValue : oldValue;
                //     },
                //   ),
                // ],
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
