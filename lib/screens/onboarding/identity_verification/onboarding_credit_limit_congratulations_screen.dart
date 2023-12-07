import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/circular_loading_indicator.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/custom_builder.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingCreditLimitCongratsScreen extends StatefulWidget {
  static const routeName = '/onboardingCreditLimitCongratsScreen';
  const OnboardingCreditLimitCongratsScreen({super.key});

  @override
  State<OnboardingCreditLimitCongratsScreen> createState() => _OnboardingCreditLimitCongratsScreenState();
}

class _OnboardingCreditLimitCongratsScreenState extends State<OnboardingCreditLimitCongratsScreen> {
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    _continueButtonController.setDisabled();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = ClientConfig.getCustomClientUiSettings().defaultScreenLeftPadding;
    double middleOfIsSuccessIcon = 32;

    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
          identityVerificationState: store.state.onboardingIdentityVerificationState),
      onInit: (store) => store.dispatch(GetCreditLimitCommandAction()),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.creditLimit != null) {
          _continueButtonController.setEnabled();
        } else {
          _continueButtonController.setDisabled();
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
                        child: Container(
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
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
                        ),
                        builder: (context, child) {
                          return (viewModel.creditLimit != null)
                              ? IvoryAssetWithBadge(
                                  childWidget: child!,
                                  childPosition: BadgePosition.topStart(
                                      start: screenWidth / 2 - horizontalPadding - middleOfIsSuccessIcon,
                                      top: -middleOfIsSuccessIcon),
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
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => PrimaryButton(
                            text: 'Continue',
                            isLoading: (viewModel.creditLimit != null)
                                ? viewModel.isLoading
                                : _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    if (viewModel.creditLimit != null) {
                                      StoreProvider.of<AppState>(context).dispatch(FinalizeIdCommandAction());
                                    }
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
