import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/button.dart';
import '../../widgets/modal.dart';

class ChangeRepaymentRateScreen extends StatelessWidget {
  static const routeName = "/changeRepaymentRateScreen";

  const ChangeRepaymentRateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings()
              .defaultScreenHorizontalPadding,
        ),
        child: Column(
          children: [
            const AppToolbar(),
            Text(
              'Change repayment rate',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text(
              'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 24),
            const ChooseRepaymentType(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Save changes",
                disabledColor: const Color(0xFFDFE2E6),
                color: const Color(0xFF2575FC),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RepaymentSuccessfullyChanged.routeName,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class ChooseRepaymentType extends StatefulWidget {
  const ChooseRepaymentType({super.key});

  @override
  State<ChooseRepaymentType> createState() => _ChooseRepaymentTypeState();
}

class _ChooseRepaymentTypeState extends State<ChooseRepaymentType> {
  RepaymentType _selectedOption = RepaymentType.percentage;

  double sliderValue = 0.2;
  double min = 0.05;
  double max = 0.9;

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
          Row(
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
                      : 'Fixed repayment',
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
          if (type == RepaymentType.percentage && type == _selectedOption) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Choose your preferred percentage rate. The minimum is 5% and the maximum is 90%.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.285, // 18 / 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF15141E),
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
                        activeTrackColor: const Color(0xFF2575FC),
                        inactiveTrackColor: const Color(0xFFE9EAEB),
                        thumbColor: const Color(0xFF071034),
                        thumbShape: CustomThumb(
                          min: min,
                          max: max,
                        ),
                        // thumbShape: RoundSliderThumbShape(
                        //   enabledThumbRadius: 20,
                        // ),
                        overlayColor: const Color(0x00FFFFFF),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 20),
                        valueIndicatorColor: const Color(0xFF2575FC),
                        valueIndicatorTextStyle: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        valueIndicatorShape: const RoundSliderThumbShape(),
                      ),
                      child: Expanded(
                        child: Slider(
                          value: sliderValue,
                          onChanged: (double newValue) {
                            setState(() {
                              print('NEW VALUE ===> $newValue');
                              sliderValue = newValue.clamp(min, max);
                            });
                          },
                          onChangeEnd: (double newValue) {
                            setState(() {
                              print('FINAL VALUE ===> $newValue');
                              sliderValue = newValue.clamp(min, max);
                            });
                          },
                          min: min,
                          max: max,
                          label: '${(sliderValue * 100).round()}%',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('${(min * 100).round()}%'),
                    ),
                    Text('${(max * 100).round()}%'),
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
                      child: Text(
                        'Choose your preferred fixed rate. The minimum is €500 and the maximum is €9,000.',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.285, // 18 / 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF15141E),
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
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        // inputFormatters: <TextInputFormatter>[
                        //   FilteringTextInputFormatter.allow(
                        //       RegExp(r'^\d+\.?\d*$')),
                        // ],
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          hintText: 'Enter amount',
                          filled: true,
                          fillColor: const Color(0xFFF8F9FA),
                          prefixIcon: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFADADB4),
                                style: BorderStyle.solid,
                              ),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              color: const Color(0xFFF8F9FA),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Icon(
                                Icons.euro,
                                size: 24,
                                color: Color(0xFFADADB4),
                              ),
                            ),
                          ),
                          prefixStyle: TextField.materialMisspelledTextStyle,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFADADB4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFADADB4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
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
            ),
        ],
      ),
    );
  }
}

class CustomThumb extends SliderComponentShape {
  final double min;
  final double max;

  const CustomThumb({required this.min, required this.max});

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
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
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
    final fillPaint = Paint()
      ..color = sliderTheme!.thumbColor!
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerWithOffset = center + const Offset(0, 0);

    canvas.drawCircle(centerWithOffset,
        getPreferredSize(isEnabled, isDiscrete).width / 2, fillPaint);
    canvas.drawCircle(centerWithOffset,
        getPreferredSize(isEnabled, isDiscrete).width / 2, borderPaint);

    final valuePainter = TextPainter(
      text: TextSpan(
        text: '${(value!.clamp(min, max) * 100).round()}%',
        style: sliderTheme.valueIndicatorTextStyle,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    valuePainter.layout();
    final valueOffset = centerWithOffset -
        Offset(valuePainter.width / 2, valuePainter.height / 2);
    valuePainter.paint(canvas, valueOffset);
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
