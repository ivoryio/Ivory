import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class OnboardingStepperScreen extends StatelessWidget {
  static const routeName = "/onboardingStepperScreen";

  const OnboardingStepperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            backButtonEnabled: true,
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
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
                          Text(
                            'Let\'s get you an account!',
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularPercentProgress(
                          numberOfSegments: onboardingSteps.length,
                          currentSegment: onboardingSteps.indexOf(
                              onboardingSteps.firstWhere((element) => element.state == OnboardingStepState.inProgress)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  for (int index = 0; index < onboardingSteps.length; index++) ...[
                    OnboardingStepListTile(
                      step: onboardingSteps[index],
                      positionInList: index + 1,
                    ),
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
              child: PrimaryButton(text: "Continue", onPressed: () {}),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularPercentProgress extends StatelessWidget {
  final num numberOfSegments;
  final int currentSegment;

  const CircularPercentProgress({
    super.key,
    required this.numberOfSegments,
    required this.currentSegment,
  });

  @override
  Widget build(BuildContext context) {
    int percentValue = 1;

    if (currentSegment == 1) percentValue = 1;
    if (currentSegment == numberOfSegments) percentValue = 100;
    if (currentSegment > 1 && currentSegment < numberOfSegments) {
      percentValue = ((currentSegment / numberOfSegments) * 100).toInt();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(
          child: CircularProgressIndicator(
            value: percentValue == 1 ? 0.01 : percentValue / 100,
            strokeWidth: 5,
            backgroundColor: const Color(0xFFE9EAEB),
            valueColor: AlwaysStoppedAnimation<Color>(ClientConfig.getColorScheme().secondary),
          ),
        ),
        Center(
          child: Text(
            '$percentValue %',
            style: ClientConfig.getTextStyleScheme().labelSmall,
          ),
        )
      ],
    );
  }
}

class OnboardingStepListTile extends StatelessWidget {
  final OnboardingStep step;
  final int positionInList;

  const OnboardingStepListTile({
    super.key,
    required this.step,
    required this.positionInList,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE9EAEB)),
        color: step.state != OnboardingStepState.inProgress ? const Color(0xFFF8F9FA) : const Color(0xFFFFFFFF),
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
                if (step.state == OnboardingStepState.completed) ...[
                  TileIcon(
                    state: step.state,
                    positionInList: positionInList,
                  )
                ],
                if (step.state == OnboardingStepState.inProgress) ...[
                  TileIcon(
                    state: step.state,
                    positionInList: positionInList,
                  )
                ],
                if (step.state == OnboardingStepState.notStarted) ...[
                  TileIcon(
                    state: step.state,
                    positionInList: positionInList,
                  )
                ],
                const SizedBox(width: 16),
                Text(
                  step.title,
                  style: (step.state == OnboardingStepState.notStarted)
                      ? ClientConfig.getTextStyleScheme().labelMedium.copyWith(color: const Color(0xFFADADB4))
                      : ClientConfig.getTextStyleScheme().labelMedium,
                ),
                const Spacer(),
                if (step.state == OnboardingStepState.inProgress) ...[
                  Row(
                    children: [
                      Text('${step.timeEstimation} MIN'),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/clock.svg', width: 16, height: 16),
                    ],
                  ),
                ] else if (step.state == OnboardingStepState.notStarted) ...[
                  Row(
                    children: [
                      Text('${step.timeEstimation} MIN',
                          style: ClientConfig.getTextStyleScheme().labelCaps.copyWith(color: const Color(0xFFADADB4))),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/clock.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(Color(0xFFADADB4), BlendMode.srcIn))
                    ],
                  ),
                ] else
                  const Text(''),
              ],
            ),
            if (step.state == OnboardingStepState.inProgress) ...[
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
          border: Border.all(width: 2, color: Color(0xFFADADB4)),
          shape: BoxShape.circle,
          color: const Color(0x00000000),
        ),
        child: Center(
          child: Text(
            '$positionInList',
            style: const TextStyle(
              color: Color(0xFFADADB4),
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
    state: OnboardingStepState.inProgress,
  ),
  OnboardingStep(
    type: OnboardingStepType.personalDetails,
    title: 'Personal details',
    description: 'We\'ll need a few personal details from you. Rest assured your data is in good hands with us.',
    timeEstimation: 3,
    state: OnboardingStepState.notStarted,
  ),
  OnboardingStep(
    type: OnboardingStepType.financialDetails,
    title: 'Financial details',
    description:
        'Tailored to your financial needs, we\'ll gather essential information through a few simple questions.',
    timeEstimation: 5,
    state: OnboardingStepState.notStarted,
  ),
  OnboardingStep(
    type: OnboardingStepType.identityVerification,
    title: 'Identity verification',
    description: 'Verify your identity quickly and easily with your preferred method.',
    timeEstimation: 15,
    state: OnboardingStepState.notStarted,
  ),
  OnboardingStep(
    type: OnboardingStepType.cardConfiguration,
    title: 'Card configuration',
    description: 'Provide your reference account, select your repayment option and let\'s get you your credit card.',
    timeEstimation: 1,
    state: OnboardingStepState.notStarted,
  ),
];

class OnboardingStep {
  final OnboardingStepType type;
  final String title;
  final String description;
  final int timeEstimation;
  final OnboardingStepState state;

  OnboardingStep({
    required this.type,
    required this.title,
    required this.description,
    required this.timeEstimation,
    required this.state,
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
