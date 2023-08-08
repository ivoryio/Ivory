import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
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
            AppToolbar(),
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
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: PrimaryButton(
                text: "Save changes",
                disabledColor: const Color(0xFFDFE2E6),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    // return Screen(
    //   scrollPhysics: const NeverScrollableScrollPhysics(),
    //   titleTextStyle: const TextStyle(
    //     fontSize: 16,
    //     height: 24 / 16,
    //     fontWeight: FontWeight.w600,
    //   ),
    //   backButtonIcon: const Icon(Icons.arrow_back, size: 24),
    //   customBackButtonCallback: () {
    //     context.push(repaymentsRoute.path);
    //   },
    //   centerTitle: true,
    //   hideAppBar: false,
    //   hideBackButton: false,
    //   hideBottomNavbar: true,
    //   child: Column(
    //     children: [
    //       Expanded(
    //         child: Padding(
    //           padding: EdgeInsets.fromLTRB(
    //             ClientConfig.getCustomClientUiSettings()
    //                 .defaultScreenVerticalPadding,
    //             ClientConfig.getCustomClientUiSettings()
    //                 .defaultScreenVerticalPadding,
    //             ClientConfig.getCustomClientUiSettings()
    //                 .defaultScreenVerticalPadding,
    //             8,
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         'Change repayment rate',
    //                         style: ClientConfig.getTextStyleScheme().heading1,
    //                       ),
    //                       const SizedBox(height: 16),
    //                       Text(
    //                         'You can decide whether you prefer the flexibility of a percentage rate repayment or the predictability of fixed repayments.',
    //                         style: ClientConfig.getTextStyleScheme()
    //                             .bodyLargeRegular,
    //                       ),
    //                     ],
    //                   ),
    //                   const SizedBox(height: 24),
    //                   const ChooseRepaymentType(),
    //                 ],
    //               ),
    //               SizedBox(
    //                 width: double.infinity,
    //                 height: 48,
    //                 child: PrimaryButton(
    //                   text: "Save changes",
    //                   disabledColor: const Color(0xFFDFE2E6),
    //                   onPressed: () {
    //                     Navigator.of(context, rootNavigator: true).pop();
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRepaymentOption(type: RepaymentType.percentage),
        const SizedBox(height: 16),
        _buildRepaymentOption(type: RepaymentType.fixed),
      ],
    );
  }

  Widget _buildRepaymentOption({required RepaymentType type}) {
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
                      data: const SliderThemeData(
                        trackHeight: 8,
                        activeTrackColor: Color(0xFF2575FC),
                        inactiveTrackColor: Color(0xFFE9EAEB),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 18),
                        thumbColor: Color(0xFF071034),
                        overlayColor: Color(0x00FFFFFF),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 20),
                        valueIndicatorColor: Color(0xFF255FC),
                        valueIndicatorTextStyle: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        showValueIndicator: ShowValueIndicator.always,
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
                          },
                          min: 0.05,
                          max: 0.9,
                          label: '${(sliderValue * 100).round()}%',
                        ),
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('5%'),
                    ),
                    Text('90%'),
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
                        //   // FilteringTextInputFormatter.allow(
                        //   //     RegExp(r'^\d*(\.?)\d*$')),
                        //   FilteringTextInputFormatter.digitsOnly ,
                        // ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: Color(0xFFF8F9FA),
                          prefixIcon: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xFFADADB4),
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              color: Color(0xFFF8F9FA),
                            ),
                            child: Padding(
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFADADB4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFFADADB4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
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

class ChooseFixedRate extends StatelessWidget {
  const ChooseFixedRate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      Text('Here will be the text field'),
    ]);
  }
}

enum RepaymentType {
  percentage,
  fixed,
}
