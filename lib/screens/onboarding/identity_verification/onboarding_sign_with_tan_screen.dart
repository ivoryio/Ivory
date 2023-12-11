import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_identity_verification_error_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_scoring_waiting_screen.dart';
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
  final GlobalKey<TanInputState> _tanInputKey = GlobalKey<TanInputState>();
  final TextEditingController _tanController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  final Duration _stepTime = const Duration(minutes: 4, seconds: 59);
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
      if (!mounted) {
        timer.cancel();
        return;
      }

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
  void dispose() {
    _tanController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: store.state.onboardingIdentityVerificationState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (previousViewModel?.errorType == null &&
            newViewModel.errorType == OnboardingIdentityVerificationErrorType.invalidTan) {
          showBottomModal(
            context: context,
            showCloseButton: false,
            title: 'Code is incorrect',
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
                    _tanController.clear();
                    _startTimer();
                    Navigator.pop(context);

                    StoreProvider.of<AppState>(context).dispatch(AuthorizeIdentificationSigningCommandAction());
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }

        if (newViewModel.isTanConfirmed == true) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingScoringWaitingScreen.routeName, (_) => false);
        }
      },
      distinct: true,
      builder: (context, viewModel) {
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
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(AuthorizeIdentificationSigningCommandAction());

                                          Navigator.pushReplacementNamed(
                                              context, OnboardingSignWithTanScreen.routeName);
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
                            TextSpan(
                                text: '6-digit code', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: ' we sent to '),
                            TextSpan(
                                text: '+49 (30) 4587 8734',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
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
                                    _tanController.clear();
                                    _countdownTimer = const Duration(seconds: 59);
                                    _startTimer();

                                    StoreProvider.of<AppState>(context)
                                        .dispatch(AuthorizeIdentificationSigningCommandAction());
                                  })),
                      ),
                      const SizedBox(height: 16),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => PrimaryButton(
                            text: 'Confirm and sign',
                            isLoading: viewModel.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(SignWithTanCommandAction(tan: _tanController.text));
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
      },
    );
  }
}
