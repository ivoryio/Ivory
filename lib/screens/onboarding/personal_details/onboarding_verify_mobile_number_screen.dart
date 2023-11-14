import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/onboarding/personal_details/onboarding_personal_details_presenter.dart';
import 'package:solarisdemo/models/onboarding/onboarding_personal_details_error_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/personal_details/onboarding_personal_details_action.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

import '../../../config.dart';

class OnboardingVerifyMobileNumberScreen extends StatefulWidget {
  static const routeName = '/onboardingVerifyMobileNumberScreen';
  const OnboardingVerifyMobileNumberScreen({super.key});

  @override
  State<OnboardingVerifyMobileNumberScreen> createState() => _OnboardingVerifyMobileNumberScreenState();
}

class _OnboardingVerifyMobileNumberScreenState extends State<OnboardingVerifyMobileNumberScreen> {
  late TextEditingController _tanInputController;
  late ContinueButtonController _continueButtonController;
  final Duration _countdownDuration = const Duration(seconds: 60);
  Duration _currentDuration = const Duration();
  Timer? _countdownTimer;

  @override
  void initState() {
    _tanInputController = TextEditingController();
    _continueButtonController = ContinueButtonController();
    super.initState();
  }

  void updateInputComplete(bool isComplete) {
    if (isComplete) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  void startTimer() {
    _currentDuration = _countdownDuration;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentDuration.inSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _currentDuration -= const Duration(seconds: 1);
        });
      }
    });
    _continueButtonController.setDisabled();
  }

  String get timerText => _currentDuration.toString().split('.').first.padLeft(8, "0").substring(3);

  @override
  void dispose() {
    _tanInputController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingPersonalDetailsViewModel>(
      converter: (store) => OnboardingPersonalDetailsPresenter.presentOnboardingPersonalDetails(
        onboardingPersonalDetailsState: store.state.onboardingPersonalDetailsState,
      ),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isLoading) {
          _continueButtonController.setLoading();
        }
        if (previousViewModel!.errorType == null &&
            newViewModel.errorType == OnboardingPersonalDetailsErrorType.invalidTan) {
          showBottomModal(
            context: context,
            showCloseButton: true,
            title: "Code is incorrect",
            textWidget: const Text(
              'Please try again. After tapping the button below, we will send you a new code.',
            ),
            content: Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Try again with new code',
                    onPressed: () async {
                      StoreProvider.of<AppState>(context).dispatch(
                        VerifyMobileNumberCommandAction(
                          mobileNumber: newViewModel.attributes.mobileNumber!,
                        ),
                      );
                      _continueButtonController.setDisabled();
                      _tanInputController.clear();
                      startTimer();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (newViewModel.isMobileConfirmed == true) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingStepperScreen.routeName, (route) => false);
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          shouldPop: !viewModel.isLoading,
          body: Column(
            children: [
              AppToolbar(
                richTextTitle: StepRichTextTitle(step: 4, totalSteps: 4),
                actions: const [
                  AppbarLogo(),
                ],
                backButtonEnabled: false,
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              AnimatedLinearProgressIndicator.step(
                current: 4,
                totalSteps: 4,
              ),
              Expanded(
                child: Padding(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        "Verify mobile number",
                        style: ClientConfig.getTextStyleScheme().heading1,
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          children: [
                            const TextSpan(text: 'Please enter below the '),
                            TextSpan(
                                text: '6-digit code ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: 'we sent to '),
                            TextSpan(
                                text: '${viewModel.attributes.mobileNumber}',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TanInput(
                        hintText: '#',
                        length: 6,
                        onCompleted: (String tan) {
                          if (tan.length == 6) {
                            _continueButtonController.setEnabled();
                          } else {
                            _continueButtonController.setDisabled();
                          }
                        },
                        controller: _tanInputController,
                        updateInputComplete: updateInputComplete,
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => InkWell(
                          onTap: _currentDuration.inSeconds > 0 || _continueButtonController.isEnabled
                              ? null
                              : () {
                                  StoreProvider.of<AppState>(context).dispatch(
                                    VerifyMobileNumberCommandAction(
                                      mobileNumber: viewModel.attributes.mobileNumber!,
                                    ),
                                  );
                                  startTimer();
                                },
                          child: Container(
                            height: 48,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              _currentDuration.inSeconds > 0 ? "Request new code in $timerText" : "Request new code",
                              style: _currentDuration.inSeconds > 0 || _continueButtonController.isEnabled
                                  ? ClientConfig.getTextStyleScheme()
                                      .bodyLargeRegularBold
                                      .copyWith(color: ClientConfig.getCustomColors().neutral500)
                                  : ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                        color: ClientConfig.getColorScheme().tertiary,
                                      ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ListenableBuilder(
                          listenable: _continueButtonController,
                          builder: (context, child) => PrimaryButton(
                            text: "Confirm",
                            isLoading: _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      ConfirmMobileNumberCommandAction(
                                        mobileNumber: viewModel.attributes.mobileNumber!,
                                        token: _tanInputController.text,
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ),
                      ),
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
