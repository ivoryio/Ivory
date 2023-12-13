import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_loading_indicator.dart';
import 'package:solarisdemo/widgets/custom_builder.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingCreditLimitCongratulationsScreen extends StatefulWidget {
  static const routeName = '/onboardingCreditLimitCongratsScreen';
  const OnboardingCreditLimitCongratulationsScreen({super.key});

  @override
  State<OnboardingCreditLimitCongratulationsScreen> createState() => _OnboardingCreditLimitCongratulationsScreenState();
}

class _OnboardingCreditLimitCongratulationsScreenState extends State<OnboardingCreditLimitCongratulationsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = ClientConfig.getCustomClientUiSettings().defaultScreenLeftPadding;
    double halfBadgeSize = IvoryAssetWithBadge.badgeSize / 2;

    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      onInit: (store) => store.dispatch(GetCreditLimitCommandAction()),
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: store.state.onboardingIdentityVerificationState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isIdentificationSuccessful == true) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingStepperScreen.routeName, (route) => false);
        } else if (newViewModel.errorType != null) {
          _showServerErrorBottomSheet(context);
        }
      },
      distinct: true,
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                richTextTitle: StepRichTextTitle(step: 7, totalSteps: 7),
                actions: const [AppbarLogo()],
                backButtonEnabled: false,
              ),
              AnimatedLinearProgressIndicator.step(
                current: 7,
                totalSteps: 7,
                isCompleted: true,
              ),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Congratulations!', style: ClientConfig.getTextStyleScheme().heading2)),
                      const SizedBox(height: 24),
                      Text(
                          'We\'re thrilled to inform you that your credit score has been approved and we\'re delighted to offer you the following credit limit:',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                      const SizedBox(height: 24),
                      CustomBuilder(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x12000000),
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: SvgPicture(
                                SvgAssetLoader(
                                  'assets/images/credit_limit.svg',
                                  colorMapper: IvoryColorMapper(
                                    baseColor: ClientConfig.getColorScheme().secondary,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 8),
                                Text('Your credit limit',
                                    style: ClientConfig.getTextStyleScheme()
                                        .labelMedium
                                        .copyWith(color: ClientConfig.getCustomColors().neutral700)),
                                const SizedBox(height: 4),
                                (viewModel.creditLimit != null)
                                    ? Text('€${NumberFormat('#,###').format(viewModel.creditLimit)}',
                                        style: ClientConfig.getTextStyleScheme().heading1)
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: CircularLoadingIndicator(
                                          width: 24,
                                          strokeWidth: 3,
                                          clockwise: true,
                                          gradientColors: [
                                            const Color(0xFFD9D9D9),
                                            ClientConfig.getColorScheme().secondary,
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        builder: (context, child) {
                          return (viewModel.creditLimit != null)
                              ? IvoryAssetWithBadge(
                                  childWidget: child!,
                                  childPosition: BadgePosition.topStart(
                                      start: screenWidth / 2 - horizontalPadding - halfBadgeSize, top: -halfBadgeSize),
                                  isSuccess: true,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 32),
                                  child: child!,
                                );
                        },
                      ),
                      const Spacer(),
                      const SizedBox(height: 16),
                      PrimaryButton(
                          text: 'Continue',
                          isLoading: (viewModel.creditLimit != null) && viewModel.isLoading,
                          onPressed: (viewModel.creditLimit != null)
                              ? () {
                                  if (viewModel.creditLimit != null) {
                                    StoreProvider.of<AppState>(context).dispatch(FinalizeIdentificationCommandAction());
                                  }
                                }
                              : null),
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

  void _showServerErrorBottomSheet(BuildContext context) {
    showBottomModal(
      context: context,
      showCloseButton: false,
      isDismissible: false,
      title: 'Server error',
      textWidget: RichText(
        text: TextSpan(style: ClientConfig.getTextStyleScheme().bodyLargeRegular, children: [
          const TextSpan(
            text:
                'We encountered an unexpected technical error. Please try again. If the issue persists, please contact our support team at ',
          ),
          TextSpan(
              text: "+49 (0)123 456789",
              style: ClientConfig.getTextStyleScheme()
                  .bodyLargeRegularBold
                  .copyWith(color: ClientConfig.getColorScheme().secondary),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final telUri = Uri(
                    scheme: 'tel',
                    path: '+490123456789',
                  );

                  if (await canLaunchUrl(telUri)) {
                    await launchUrl(telUri);
                  }
                }),
          const TextSpan(text: '.')
        ]),
      ),
      content: Column(
        children: [
          const SizedBox(height: 24),
          PrimaryButton(
            text: "Try again",
            onPressed: () {
              Navigator.pop(context);
              StoreProvider.of<AppState>(context).dispatch(FinalizeIdentificationCommandAction());
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
