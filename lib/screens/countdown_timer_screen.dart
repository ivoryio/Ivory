import 'dart:async';

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

class CountdownTimerScreen extends StatefulWidget {
  static const routeName = '/countdownTimerScreen';

  const CountdownTimerScreen({super.key});

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  final GlobalKey<TanInputState> _tanInputKey = GlobalKey<TanInputState>();
  final TextEditingController _tanController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  final CountdownTimerController _screenCountdownController = CountdownTimerController(
    duration: const Duration(seconds: 10),
  );

  final CountdownTimerController _requestNewTanCountdownController = CountdownTimerController(
    duration: const Duration(seconds: 10),
  );

  @override
  void initState() {
    super.initState();

    _screenCountdownController.start();
    _requestNewTanCountdownController.start();
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
                          controller: _screenCountdownController,
                          onCompleted: () {
                            showBottomModal(
                              context: context,
                              showCloseButton: false,
                              isDismissible: false,
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
                                      _screenCountdownController.reset();
                                      Navigator.pop(context);
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
                    key: _tanInputKey,
                    length: 6,
                    controller: _tanController,
                    focusNode: _focusNode,
                    isLoading: _continueButtonController.isLoading,
                    onChanged: (tan) {},
                  ),
                  const Spacer(),
                  PrimaryButton(text: "Reset countdown", onPressed: () => _screenCountdownController.reset()),
                  const SizedBox(height: 16),
                  PrimaryButton(text: "Reset request tan", onPressed: () => _requestNewTanCountdownController.reset()),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _requestNewTanCountdownController,
                    builder: (context, child) {
                      if (_requestNewTanCountdownController.isCompleted) {
                        return Text.rich(TextSpan(
                            text: 'Request new code',
                            style: ClientConfig.getTextStyleScheme()
                                .labelMedium
                                .copyWith(color: ClientConfig.getColorScheme().secondary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _tanController.clear();
                                _requestNewTanCountdownController.reset();
                              }));
                      }

                      return Text('Request new code in ${_requestNewTanCountdownController.formattedRemainingDuration}',
                          style: ClientConfig.getTextStyleScheme()
                              .labelMedium
                              .copyWith(color: ClientConfig.getCustomColors().neutral500));
                    },
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => PrimaryButton(
                        text: 'Confirm and sign',
                        isLoading: _continueButtonController.isLoading,
                        onPressed: _continueButtonController.isEnabled ? () {} : null),
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
