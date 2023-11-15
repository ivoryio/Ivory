import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/onboarding/identity_verification/onboarding_video_identification_not_available_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/radio_select_list.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingIdentityVerificationMethodScreen extends StatefulWidget {
  static const routeName = "/onboardingIdentityVerificationMethodScreen";

  const OnboardingIdentityVerificationMethodScreen({super.key});

  @override
  State<OnboardingIdentityVerificationMethodScreen> createState() => _OnboardingIdentityVerificationMethodScreenState();
}

class _OnboardingIdentityVerificationMethodScreenState extends State<OnboardingIdentityVerificationMethodScreen> {
  final _selectedIdentificationMethod = ValueNotifier<RadioSelectItem?>(null);

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            richTextTitle: StepRichTextTitle(step: 1, totalSteps: 7),
            actions: const [AppbarLogo()],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          AnimatedLinearProgressIndicator.step(current: 1, totalSteps: 7),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Choose your preferred identity verification method',
                    style: ClientConfig.getTextStyleScheme().heading2,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: RadioSelectList(
                      onSelectionChanged: (item) {},
                      selectedValueNotifier: _selectedIdentificationMethod,
                      items: const [
                        RadioSelectItem(
                          title: "Bank Identification",
                          subtitle:
                              "We will verify your identity by triggering a transfer of 0.01€ from your reference bank account. Available anytime.",
                          timeEstimation: "2 MIN",
                          value: "bankIdentification",
                        ),
                        RadioSelectItem(
                          title: "Video Identification",
                          subtitle:
                              "One of our agents will verify your identity in a very short video call. Available from Monday to Sunday, 8:00 - 24:00 CEST.",
                          timeEstimation: "5-15 MIN",
                          value: "videoIdentification",
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: _selectedIdentificationMethod,
                    builder: (context, child) => PrimaryButton(
                      text: "Continue",
                      onPressed: _selectedIdentificationMethod.value != null
                          ? () {
                              final identificationMethod = _selectedIdentificationMethod.value?.value;

                              if (identificationMethod == "videoIdentification") {
                                Navigator.pushNamed(context, OnboardingVideoIdentificationNotAvailableScreen.routeName);
                              }
                            }
                          : null,
                    ),
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
