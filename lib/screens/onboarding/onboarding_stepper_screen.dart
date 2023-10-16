import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/sign_up/onboarding_basic_info_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_percent_indicator.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingStepperScreenParams {
  final OnboardingStepType step;

  OnboardingStepperScreenParams({
    required this.step,
  });
}

class OnboardingStepperScreen extends StatelessWidget {
  static const routeName = "/onboardingStepperScreen";
  final OnboardingStepperScreenParams params;

  const OnboardingStepperScreen({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    int currentStep = onboardingSteps.indexWhere((step) => step.type == params.step);

    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            actions: [
              SvgPicture.asset("assets/icons/default/appbar_logo.svg"),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your progress',
                            style: ClientConfig.getTextStyleScheme().heading1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularPercentIndicator(
                          percent: currentStep == 0 ? 0.01 : currentStep / onboardingSteps.length,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: (currentStep != 0)
                        ? Text(
                            'If you need to pause at any point, you can sign in later and pick up right where you left off.',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          )
                        : Text(
                            'Let\'s get you an account!',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          ),
                  ),
                  const SizedBox(height: 24),
                  for (int index = 0; index < onboardingSteps.length; index++) ...[
                    if (currentStep < index)
                      OnboardingStepListTile(
                          step: onboardingSteps[index],
                          positionInList: index + 1,
                          state: OnboardingStepState.notStarted),
                    if (currentStep > index)
                      OnboardingStepListTile(
                          step: onboardingSteps[index],
                          positionInList: index + 1,
                          state: OnboardingStepState.completed),
                    if (currentStep == index)
                      OnboardingStepListTile(
                          step: onboardingSteps[index],
                          positionInList: index + 1,
                          state: OnboardingStepState.inProgress),
                    if (index != onboardingSteps.length - 1) const SizedBox(height: 16),
                  ]
                ],
              ),
            ),
          ),
          Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Continue",
                onPressed: () {
                  Navigator.pushNamed(context, OnboardingBasicInfoScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingStepListTile extends StatelessWidget {
  final OnboardingStep step;
  final OnboardingStepState state;
  final int positionInList;

  const OnboardingStepListTile({
    super.key,
    required this.step,
    required this.state,
    required this.positionInList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ClientConfig.getCustomColors().neutral200, width: 1),
        color: state != OnboardingStepState.inProgress
            ? ClientConfig.getCustomColors().neutral100
            : ClientConfig.getColorScheme().background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state == OnboardingStepState.completed) ...[
                  TileIcon(
                    state: state,
                    positionInList: positionInList,
                  )
                ],
                if (state == OnboardingStepState.inProgress) ...[
                  TileIcon(
                    state: state,
                    positionInList: positionInList,
                  )
                ],
                if (state == OnboardingStepState.notStarted) ...[
                  TileIcon(
                    state: state,
                    positionInList: positionInList,
                  )
                ],
                const SizedBox(width: 16),
                Text(
                  step.title,
                  style: (state == OnboardingStepState.notStarted)
                      ? ClientConfig.getTextStyleScheme()
                          .labelMedium
                          .copyWith(color: ClientConfig.getCustomColors().neutral500)
                      : ClientConfig.getTextStyleScheme().labelMedium,
                ),
                const Spacer(),
                if (state == OnboardingStepState.inProgress) ...[
                  Row(
                    children: [
                      Text('${step.timeEstimation} MIN', style: ClientConfig.getTextStyleScheme().labelCaps),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/clock.svg', width: 16, height: 16),
                    ],
                  ),
                ] else if (state == OnboardingStepState.notStarted) ...[
                  Row(
                    children: [
                      Text('${step.timeEstimation} MIN',
                          style: ClientConfig.getTextStyleScheme()
                              .labelCaps
                              .copyWith(color: ClientConfig.getCustomColors().neutral500)),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/clock.svg',
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(ClientConfig.getCustomColors().neutral500, BlendMode.srcIn))
                    ],
                  ),
                ] else
                  const Text(''),
              ],
            ),
            if (state == OnboardingStepState.inProgress) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 48),
                  Flexible(
                    child: Text(
                      step.description,
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TileIcon extends StatelessWidget {
  final OnboardingStepState state;
  final int positionInList;

  const TileIcon({
    super.key,
    required this.state,
    required this.positionInList,
  });

  @override
  Widget build(BuildContext context) {
    if (state == OnboardingStepState.completed) {
      return InkWell(
        onTap: () {},
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ClientConfig.getColorScheme().secondary,
          ),
          child: Icon(Icons.check, size: 16, color: ClientConfig.getColorScheme().surface),
        ),
      );
    }
    if (state == OnboardingStepState.inProgress) {
      return InkWell(
        onTap: () {},
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ClientConfig.getColorScheme().primary,
          ),
          child: Center(
            child: Text(
              '$positionInList',
              style: TextStyle(color: ClientConfig.getColorScheme().surface, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {},
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ClientConfig.getCustomColors().neutral500),
          shape: BoxShape.circle,
          color: const Color(0x00000000),
        ),
        child: Center(
          child: Text(
            '$positionInList',
            style: TextStyle(
              color: ClientConfig.getCustomColors().neutral500,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

List<OnboardingStep> onboardingSteps = [
  OnboardingStep(
    type: OnboardingStepType.signUp,
    title: 'Sign up',
    description: 'Fill in your title, name, email address and choose your password. It\'s that easy.',
    timeEstimation: 2,
  ),
  OnboardingStep(
    type: OnboardingStepType.personalDetails,
    title: 'Personal details',
    description: 'We\'ll need a few personal details from you. Rest assured your data is in good hands with us.',
    timeEstimation: 3,
  ),
  OnboardingStep(
    type: OnboardingStepType.financialDetails,
    title: 'Financial details',
    description:
        'Tailored to your financial needs, we\'ll gather essential information through a few simple questions.',
    timeEstimation: 5,
  ),
  OnboardingStep(
    type: OnboardingStepType.identityVerification,
    title: 'Identity verification',
    description: 'Verify your identity quickly and easily with your preferred method.',
    timeEstimation: 15,
  ),
  OnboardingStep(
    type: OnboardingStepType.cardConfiguration,
    title: 'Card configuration',
    description: 'Provide your reference account, select your repayment option and let\'s get you your credit card.',
    timeEstimation: 1,
  ),
];

class OnboardingStep {
  final OnboardingStepType type;
  final String title;
  final String description;
  final int timeEstimation;

  OnboardingStep({
    required this.type,
    required this.title,
    required this.description,
    required this.timeEstimation,
  });
}

enum OnboardingStepType {
  signUp,
  personalDetails,
  financialDetails,
  identityVerification,
  cardConfiguration,
}

enum OnboardingStepState {
  completed,
  inProgress,
  notStarted,
}
