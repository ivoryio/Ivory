import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_countdown_progress_widget.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class OnboardingSignWithTanScreen extends StatefulWidget {
  static const String routeName = '/onboarding/signWithTan';
  const OnboardingSignWithTanScreen({super.key});

  @override
  State<OnboardingSignWithTanScreen> createState() => _OnboardingSignWithTanScreenState();
}

class _OnboardingSignWithTanScreenState extends State<OnboardingSignWithTanScreen> {
  final TextEditingController _tanController = TextEditingController();
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  final Duration _stepTime = const Duration(seconds: 299);
  Duration _countdownTimer = const Duration(seconds: 59);

  @override
  void initState() {
    super.initState();
    _continueButtonController.setDisabled();

    _startTimer();

    _tanController.addListener(_validToContinue);
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);

    Timer.periodic(oneSec, (Timer timer) {
      if (_countdownTimer.inSeconds == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _countdownTimer = _countdownTimer - oneSec;
        });
      }
    });
  }

  void _validToContinue() {
    if (_tanController.text.length == 6) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 5, totalSteps: 7),
            actions: const [AppbarLogo()],
            backButtonEnabled: false,
          ),
          AnimatedLinearProgressIndicator.step(current: 5, totalSteps: 7),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: Text('Sign the contracts with a TAN code',
                              style: ClientConfig.getTextStyleScheme().heading2)),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularCountdownProgress(
                          duration: _stepTime,
                          onCompleted: () {
                            showBottomModal(
                              context: context,
                              showCloseButton: false,
                              title: 'Time has expired',
                              textWidget: Text(
                                'Please try again. After tapping the button below, we will send you a new code.',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                              ),
                              content: Column(
                                children: [
                                  const SizedBox(height: 24),
                                  PrimaryButton(
                                    text: "Try again with new TAN",
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => const OnboardingSignWithTanScreen()),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    TextSpan(
                      text: 'Please enter below the ',
                      children: [
                        TextSpan(text: '6-digit code', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(text: ' we sent to '),
                        TextSpan(
                            text: '+49 (30) 4587 8734', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(text: '. You have '),
                        TextSpan(text: '5 minutes', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(
                            text:
                                ' to complete this step. If you are unable to enter the code within this time, you can retry and you will receive a new TAN code. The timer will be reset.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TanInput(
                    length: 6,
                    hintText: '#',
                    onCompleted: (String tan) {
                      log('signWithTan ===> $tan');
                    },
                    controller: _tanController,
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 48,
                    alignment: Alignment.center,
                    child: (_countdownTimer.inSeconds > 0)
                        ? Text('Request new code in 0:${_countdownTimer.inSeconds.toString().padLeft(2, '0')}',
                            style: ClientConfig.getTextStyleScheme()
                                .labelMedium
                                .copyWith(color: ClientConfig.getCustomColors().neutral500))
                        : Text.rich(TextSpan(
                            text: 'Request new code',
                            style: ClientConfig.getTextStyleScheme()
                                .labelMedium
                                .copyWith(color: ClientConfig.getColorScheme().secondary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  _countdownTimer = const Duration(seconds: 59);
                                });

                                _startTimer();
                              })),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => PrimaryButton(
                        text: 'Confirm and sign',
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled
                            ? () {
                                log('_tanController ===> ${_tanController.text}');
                              }
                            : null),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
