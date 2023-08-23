import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/button.dart';
import '../../widgets/modal.dart';

class ChangeRepaymentRateScreen extends StatefulWidget {
  static const routeName = "/changeRepaymentRateScreen";

  const ChangeRepaymentRateScreen({super.key});

  @override
  State<ChangeRepaymentRateScreen> createState() =>
      _ChangeRepaymentRateScreenState();
}

class _ChangeRepaymentRateScreenState extends State<ChangeRepaymentRateScreen> {
  final TextEditingController _controller =
      TextEditingController(text: '500.00');
  bool _canContinue = false;

  void _updateCanContinue() {
    if (_canContinue == true) {
      return;
    }

    setState(() {
      _canContinue = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateCanContinue);
  }

  @override
  Widget build(BuildContext context) {
    backWithoutSaving() {
      showBottomModal(
        context: context,
        title: "Are you sure you want to discard the changes?",
        message: "The changes you made will not be saved.",
        content: const ShowBottomModalActions(),
      );
    }

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
        ),
        child: Column(
          children: [
            AppToolbar(
              onBackButtonPressed:
                  (_canContinue == true) ? backWithoutSaving : null,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Change repayment rate',
                style: ClientConfig.getTextStyleScheme().heading1,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 24),
            ChooseRepaymentType(
                controller: _controller,
                onPercentageChanged: _updateCanContinue),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Save changes",
                disabledColor: const Color(0xFFDFE2E6),
                color: const Color(0xFF2575FC),
                onPressed: _canContinue
                    ? () {
                        Navigator.pushNamed(
                          context,
                          RepaymentSuccessfullyChanged.routeName,
                        );
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class ShowBottomModalActions extends StatelessWidget {
  const ShowBottomModalActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: ClientConfig.getCustomClientUiSettings()
            .defaultScreenVerticalPadding,
      ),
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
              Navigator.pushNamed(
                context,
                RepaymentsScreen.routeName,
              );
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
  final TextEditingController controller;
  final void Function() onPercentageChanged;

  const ChooseRepaymentType({
    super.key,
    required this.controller,
    required this.onPercentageChanged,
  });

  @override
  State<ChooseRepaymentType> createState() => _ChooseRepaymentTypeState();
}

class _ChooseRepaymentTypeState extends State<ChooseRepaymentType> {
  RepaymentType _selectedOption = RepaymentType.percentage;

  double sliderValue = 20;
  double min = 5;
  double max = 90;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRepaymentOptions(type: RepaymentType.percentage),
        const SizedBox(height: 16),
        _buildRepaymentOptions(type: RepaymentType.fixed),
      ],
    );
  }

  Widget _buildRepaymentOptions({required RepaymentType type}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: _selectedOption == type
                ? const Color(0xFF2575FC)
                : const Color(0xFFE9EAEB),
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _selectedOption = type),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                  activeColor: const Color(0xFF2575FC),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  value: type,
                  groupValue: _selectedOption,
                  onChanged: (RepaymentType? value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    type == RepaymentType.percentage
                        ? 'Percentage rate repayment'
                        : 'Fixed rate repayment',
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
                    final titleOfModal = type == RepaymentType.percentage
                        ? 'Percentage rate repayment'
                        : 'Fixed rate repayment';
                    final messageOfModal = type == RepaymentType.percentage
                        ? 'Reflects the overall cost of repaying credit, accounting for interest and fees. It allows for transparency and informed financial decisions.'
                        : 'Ensures stability by keeping the interest rate constant throughout the loan term. It provides predictability.';
                    showBottomModal(
                      context: context,
                      title: titleOfModal,
                      message: messageOfModal,
                    );
                  },
                ),
              ],
            ),
          ),
          if (type == RepaymentType.percentage && type == _selectedOption) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: RepaymentConditions(
                          message:
                              'Choose your preferred percentage rate. The minimum is 5% and the maximum is 90%.'),
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
                        activeTrackColor: const Color(0xFF2575FC),
                        inactiveTrackColor: const Color(0xFFE9EAEB),
                        thumbColor: const Color(0xFF071034),
                        thumbShape: CustomThumb(label: sliderValue),
                        overlayColor: const Color(0x00FFFF00),
                        valueIndicatorColor: const Color(0xFF2575FC),
                        valueIndicatorTextStyle: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
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

                            widget.onPercentageChanged();
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
          ],
          if (type == RepaymentType.fixed && type == _selectedOption)
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: RepaymentConditions(
                          message:
                              'Choose your preferred fixed rate. The minimum is €500 and the maximum is €9,000.'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(controller: widget.controller),
              ],
            ),
        ],
      ),
    );
  }
}

class RepaymentConditions extends StatelessWidget {
  final String message;
  const RepaymentConditions({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 14,
        height: 1.285,
        fontWeight: FontWeight.w400,
        color: Color(0xFF15141E),
      ),
    );
  }
}

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const CustomTextField({super.key, this.controller, this.onChanged});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _rangeError = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final RegExp regExp = RegExp(r'^\d+\.?\d*$');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: _rangeError ? Colors.red : const Color(0xFFADADB4),
                  style: BorderStyle.solid,
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: const Color(0xFFF8F9FA),
              ),
              child: const Text(
                '€',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFADADB4),
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: widget.controller,
                onChanged: (text) {
                  if (text.isEmpty) text = '0';

                  if (widget.onChanged != null) {
                    widget.onChanged!(text);
                  }

                  setState(() {
                    _rangeError =
                        (double.parse(text) < 500 || double.parse(text) > 9000);
                  });

                  if (double.parse(text) < 500) {
                    errorMessage = 'Rate is too low. The minimum is €500.';
                  }

                  if (double.parse(text) > 9000) {
                    errorMessage = 'Rate is too high. The maximum is €9,000.';
                  }
                },
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(regExp),
                  TextInputFormatter.withFunction(
                    (oldValue, newValue) {
                      final text = newValue.text;

                      if (text.isEmpty) {
                        return newValue.copyWith(text: '');
                      }

                      return (text.contains(regExp)) ? newValue : oldValue;
                    },
                  ),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    borderSide: BorderSide(
                      width: 1,
                      color: _rangeError ? Colors.red : const Color(0xFFADADB4),
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
                      color: _rangeError ? Colors.red : const Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        _rangeError
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

    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(
      text: '${label.round()}%',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();

    final textOffset = Offset(
        center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);

    textPainter.paint(canvas, textOffset);
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
