import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/repayments/repayment_successfully_changed.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class ChangeRepaymentRateScreen extends StatefulWidget {
  static const routeName = "/changeRepaymentRateScreen";

  const ChangeRepaymentRateScreen({super.key});

  @override
  State<ChangeRepaymentRateScreen> createState() => _ChangeRepaymentRateScreenState();
}

class _ChangeRepaymentRateScreenState extends State<ChangeRepaymentRateScreen> {
  final TextEditingController _initialFixedRepayment = TextEditingController(text: '500.00');
  bool _canContinue = false;

  @override
  void initState() {
    super.initState();
    _initialFixedRepayment.addListener(() {
      if (_canContinue == true) {
        return;
      }
    });

    setState(() {
      _canContinue = true;
    });
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
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppToolbar(
                    onBackButtonPressed: (_canContinue == true) ? backWithoutSaving : null,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Change repayment rate',
                            style: ClientConfig.getTextStyleScheme().heading1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                            children: [
                              const TextSpan(
                                text:
                                    'We provide fixed repayment options with flexibility. You can select your preferred fixed rate, ranging from a minimum of ',
                              ),
                              TextSpan(
                                text: '€500',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                              ),
                              const TextSpan(
                                text: ' to a maximum of ',
                              ),
                              TextSpan(
                                text: '€9,000',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                              ),
                              const TextSpan(
                                text: '.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        FixedRepayment(
                          controller: _initialFixedRepayment,
                          onFixedChanged: (value) {
                            setState(() {
                              _canContinue = value > 500 && value <= 9000;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        const PercentageRepayment(),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: Button(
                            text: "Save changes",
                            disabledColor: const Color(0xFFDFE2E6),
                            color: ClientConfig.getColorScheme().tertiary,
                            textColor: ClientConfig.getColorScheme().surface,
                            onPressed: _canContinue
                                ? () {
                                    final valueForRepayment = _initialFixedRepayment.text;
                                    final procentualValue = 5;

                                    Navigator.pushNamed(context, RepaymentSuccessfullyChangedScreen.routeName,
                                        arguments: RepaymentSuccessfullyScreenParams(
                                          fixedRate: double.parse(valueForRepayment),
                                          interestRate: procentualValue,
                                        ));
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      padding: EdgeInsets.symmetric(
        horizontal: 0,
        vertical: ClientConfig.getCustomClientUiSettings().defaultScreenVerticalPadding,
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
              Navigator.popUntil(context, (route) => route.settings.name == RepaymentsScreen.routeName);
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

class FixedRepayment extends StatelessWidget {
  final TextEditingController controller;
  final void Function(double) onFixedChanged;

  const FixedRepayment({
    super.key,
    required this.controller,
    required this.onFixedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Fixed repayment',
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: controller,
          onChanged: (textValue) {
            final value = double.tryParse(textValue);

            if (value != null) {
              onFixedChanged(value);
            }
          },
        ),
      ],
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
  bool _inRange = false;
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
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: _inRange ? Colors.red : const Color(0xFFADADB4),
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
                // onTap: () {
                //   setState(() {
                //     _inRange = false;
                //   });
                // },
                controller: widget.controller,
                onChanged: (text) {
                  if (text.isEmpty) text = '0';

                  if (widget.onChanged != null) {
                    widget.onChanged!(text);
                  }

                  setState(() {
                    _inRange = (double.parse(text) < 500 || double.parse(text) > 9000);
                  });

                  if (double.parse(text) < 500) {
                    errorMessage = 'Rate is too low. The minimum is €500.';
                  }

                  if (double.parse(text) > 9000) {
                    errorMessage = 'Rate is too high. The maximum is €9,000.';
                  }
                },
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                      color: _inRange ? Colors.red : const Color(0xFFADADB4),
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
                      color: _inRange ? Colors.red : const Color(0xFFADADB4),
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        _inRange
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

class PercentageRepayment extends StatelessWidget {
  const PercentageRepayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            width: 1,
            color: Color(0xFFE9EAEB),
            style: BorderStyle.solid,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Color(0xFFF8F9FA),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/info.svg",
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '5% interest rate',
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              'Our fixed interest rate of 5% remains the same, no matter the repayment type or rate you select. It will accrue based on your outstanding balance after the repayment has been deducted.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
        ],
      ),
    );
  }
}
