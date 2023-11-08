import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/onboarding_progress_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/onboarding_progress_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_percent_indicator.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';

class OnboardingStepperScreen extends StatefulWidget {
  static const routeName = "/onboardingStepperScreen";

  const OnboardingStepperScreen({super.key});

  @override
  State<OnboardingStepperScreen> createState() => _OnboardingStepperScreenState();
}

class _OnboardingStepperScreenState extends State<OnboardingStepperScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: StoreConnector<AppState, OnboardingProgressViewModel>(
        onInit: (store) => store.dispatch(GetOnboardingProgressCommandAction()),
        converter: (store) => OnboardingProgressPresenter.presentOnboardingProgress(
          onboardingProgressState: store.state.onboardingProgressState,
        ),
        builder: (context, viewModel) {
          return viewModel is OnboardingProgressFetchedViewModel
              ? _buildContent(context, viewModel)
              : viewModel is OnboardingProgressErrorViewModel
                  ? _buildErrorContent(context, viewModel)
                  : _buildLoadingContent(context);
        },
      ),
    );
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Column(
      children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          actions: const [AppbarLogo()],
        ),
        const Expanded(
          child: Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }

  Widget _buildErrorContent(BuildContext context, OnboardingProgressViewModel viewModel) {
    return Column(
      children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          actions: const [AppbarLogo()],
        ),
        Expanded(
          child: Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScreenTitle("An error has occured"),
                const SizedBox(height: 16),
                Text.rich(
                  TextSpan(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    children: [
                      const TextSpan(
                          text:
                              'We\'re sorry, but it seems an error has cropped up, which is preventing you from completing this step. Here\'s what you can do:\n\n'),
                      TextSpan(
                        text:
                            '1. Try closing the app and reopening it.\n\n2. Check your internet connection and try again.\n\n3. If the issue persists, reach out ',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                      ),
                      const TextSpan(text: 'to our friendly support team at '),
                      TextSpan(
                        text: '+49 (0)123 456789',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: viewModel is OnboardingProgressLoadingViewModel
                                ? ClientConfig.getCustomColors().neutral500
                                : ClientConfig.getColorScheme().secondary),
                      ),
                      const TextSpan(text: ' or '),
                      TextSpan(
                        text: 'support@ivory.com',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: viewModel is OnboardingProgressLoadingViewModel
                                ? ClientConfig.getCustomColors().neutral500
                                : ClientConfig.getColorScheme().secondary),
                      ),
                      const TextSpan(text: '. We\'re here to help.'),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(child: SvgPicture.asset('assets/images/general_error.svg')),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                      text: "Try again",
                      isLoading: viewModel is OnboardingProgressLoadingViewModel,
                      onPressed: viewModel is OnboardingProgressLoadingViewModel
                          ? null
                          : () {
                              StoreProvider.of<AppState>(context).dispatch(GetOnboardingProgressCommandAction());
                            }),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, OnboardingProgressFetchedViewModel viewModel) {
    final percent = viewModel.progress.progressPercentage / 100;
    final activeStep = viewModel.progress.activeStep;
    final routeName = viewModel.progress.routeName;

    return Column(
      children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          actions: const [AppbarLogo()],
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ScreenTitle("Your progress"),
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularPercentIndicator(percent: percent),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    viewModel.progress.activeStep != StepperItemType.signUp
                        ? 'If you need to pause at any point, you can sign in later and pick up right where you left off.'
                        : 'Let\'s get you an account!',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                ),
                const SizedBox(height: 24),
                OnboardingStepper(activeStep: activeStep),
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
              onPressed: activeStep != StepperItemType.unknown
                  ? () {
                      Navigator.pushNamed(context, routeName);
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingStepper extends StatelessWidget {
  final StepperItemType activeStep;

  const OnboardingStepper({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: OnboardingStepper.steps.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = OnboardingStepper.steps[index];

        OnboardingStepState state;
        if (activeStep == StepperItemType.unknown) {
          state = OnboardingStepState.notStarted;
        } else if (item.type == activeStep) {
          state = OnboardingStepState.inProgress;
        } else if (item.type.index < activeStep.index) {
          state = OnboardingStepState.completed;
        } else {
          state = OnboardingStepState.notStarted;
        }

        return OnboardingStepListTile(
          item: item,
          state: state,
          index: index + 1,
        );
      },
    );
  }

  static const List<OnboardingStepperItem> steps = [
    OnboardingStepperItem(
      type: StepperItemType.signUp,
      title: 'Sign up',
      description: 'Fill in your title, name, email address and choose your password. It\'s that easy.',
      timeEstimation: 2,
    ),
    OnboardingStepperItem(
      type: StepperItemType.personalDetails,
      title: 'Personal details',
      description: 'We\'ll need a few personal details from you. Rest assured your data is in good hands with us.',
      timeEstimation: 3,
    ),
    OnboardingStepperItem(
      type: StepperItemType.financialDetails,
      title: 'Financial details',
      description:
          'Tailored to your financial needs, we\'ll gather essential information through a few simple questions.',
      timeEstimation: 5,
    ),
    OnboardingStepperItem(
      type: StepperItemType.identityVerification,
      title: 'Identity verification',
      description: 'Verify your identity quickly and easily with your preferred method.',
      timeEstimation: 15,
    ),
    OnboardingStepperItem(
      type: StepperItemType.cardConfiguration,
      title: 'Card configuration',
      description: 'Provide your reference account, select your repayment option and let\'s get you your credit card.',
      timeEstimation: 1,
    ),
  ];
}

class OnboardingStepListTile extends StatelessWidget {
  final int index;
  final OnboardingStepState state;
  final OnboardingStepperItem item;

  const OnboardingStepListTile({
    super.key,
    required this.item,
    required this.state,
    required this.index,
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
                TileIcon(
                  state: state,
                  index: index,
                ),
                const SizedBox(width: 16),
                Text(
                  item.title,
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
                      Text('${item.timeEstimation} MIN', style: ClientConfig.getTextStyleScheme().labelCaps),
                      const SizedBox(width: 8),
                      SvgPicture.asset('assets/icons/clock.svg', width: 16, height: 16),
                    ],
                  ),
                ] else if (state == OnboardingStepState.notStarted) ...[
                  Row(
                    children: [
                      Text('${item.timeEstimation} MIN',
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
                      item.description,
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
  final int index;

  const TileIcon({
    super.key,
    required this.state,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (state == OnboardingStepState.completed) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ClientConfig.getColorScheme().secondary,
        ),
        child: Icon(Icons.check, size: 16, color: ClientConfig.getColorScheme().surface),
      );
    }
    if (state == OnboardingStepState.inProgress) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ClientConfig.getColorScheme().primary,
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(color: ClientConfig.getColorScheme().surface, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: ClientConfig.getCustomColors().neutral500),
        shape: BoxShape.circle,
        color: const Color(0x00000000),
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(
            color: ClientConfig.getCustomColors().neutral500,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class OnboardingStepperItem {
  final StepperItemType type;
  final String title;
  final String description;
  final int timeEstimation;

  const OnboardingStepperItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timeEstimation,
  });
}

enum OnboardingStepState {
  completed,
  inProgress,
  notStarted,
}
