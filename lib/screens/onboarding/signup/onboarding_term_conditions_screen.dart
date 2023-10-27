import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/signup/onboarding_signup_action.dart';
import 'package:solarisdemo/screens/onboarding/signup/onboarding_error_email_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingTermConditionsScreen extends StatefulWidget {
  static const routeName = "/onboardingTermConditionsScreen";

  const OnboardingTermConditionsScreen({super.key});

  @override
  State<OnboardingTermConditionsScreen> createState() => _OnboardingTermConditionsScreenState();
}

class _OnboardingTermConditionsScreenState extends State<OnboardingTermConditionsScreen> {
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  List<bool?> checkCardsValues = [false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 5, totalSteps: 5),
            actions: const [AppbarLogo()],
            backButtonAppearanceDisabled: _continueButtonController.isLoading,
          ),
          AnimatedLinearProgressIndicator.step(current: 5, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('T&Cs', style: ClientConfig.getTextStyleScheme().heading2),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: 'Please read the terms and conditions below, and agree by checking the checkboxes:',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: '1. Eligibility: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text: 'Must be 18+, meet credit requirements. Germany residents only.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: '2. Card Usage: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'Authorized transactions at accepting merchants. You\'re responsible for charges. Transaction limits may apply.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '3. Billing and Payments: ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'Monthly statement with transaction details. Pay outstanding balance by due date. Late payments incur fees. Various payment methods available.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '4. Fees and Charges: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'Annual fees, interest charges, and penalties for late payments. Fee Schedule provided upon approval.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '5. Account Security: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'Keep card and account info secure. Report lost, stolen, or compromised cards immediately. You\'re responsible for unauthorized transactions prior to notification.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: '6. Termination: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text: 'Service may be terminated for non-compliance. Contact support to cancel.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '7. Privacy and Data Protection: ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'We value your privacy. Refer to our Privacy Policy for information. By using our service, you consent to the collection, use, and disclosure of your information.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(text: '8. Amendments: ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text: 'We may update T&Cs. Changes communicated via email or our website.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '9. Data Collection and Use: ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'We collect, store, and process your personal and financial information for credit score check. Includes name, address, date of birth, and financial data.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: '10. Credit Score Results: ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      TextSpan(
                          text:
                              'Score based on available data at assessment. Not a guarantee for credit approval. For informational purposes only.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(text: 'Please check Ivory '),
                        TextSpan(
                          text: 'Customer Information on Data Processing',
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegularBold
                              .copyWith(color: const Color(0xFF406FE6)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchFileInBrowser(
                                  '/customer-information/germany/de-iban/english/customer-information-on-data-processing',
                                ),
                        ),
                        const TextSpan(text: ', '),
                        TextSpan(
                          text: 'Depositor Information Sheet',
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegularBold
                              .copyWith(color: const Color(0xFF406FE6)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchFileInBrowser(
                                '/customer-information/germany/de-iban/english/depositor-information-sheet'),
                        ),
                        const TextSpan(text: ', and '),
                        TextSpan(
                          text: 'other customer information',
                          style: ClientConfig.getTextStyleScheme()
                              .bodyLargeRegularBold
                              .copyWith(color: const Color(0xFF406FE6)),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => _launchFileInBrowser(
                                  '/en/customer-information/germany/de-iban/english/',
                                ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text:
                          'By applying and using our credit card service, you acknowledge reading, understanding, and agreeing to abide by these terms. Contact customer support for assistance.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => CheckCard(
                      isChecked: false,
                      isDisabled: _continueButtonController.isLoading,
                      onChanged: (checked) {
                        checkCardsValues[0] = checked;
                        _isSelected();
                      },
                      textFragments: firstCardTextFragments,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => CheckCard(
                      isChecked: false,
                      isDisabled: _continueButtonController.isLoading,
                      onChanged: (checked) {
                        checkCardsValues[1] = checked;
                        _isSelected();
                      },
                      textFragments: [
                        TextFragment(
                          text: 'I act only in my own economic interest and not on the initiative of a third party.',
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => CheckCard(
                      isChecked: false,
                      isDisabled: _continueButtonController.isLoading,
                      onChanged: (checked) {
                        checkCardsValues[2] = checked;
                        _isSelected();
                      },
                      textFragments: secondCardTextFragments,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => CheckCard(
                      isChecked: false,
                      isDisabled: _continueButtonController.isLoading,
                      onChanged: (checked) {
                        checkCardsValues[3] = checked;
                        _isSelected();
                      },
                      textFragments: thirdCardTextFragments,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListenableBuilder(
                    listenable: _continueButtonController,
                    builder: (context, child) => CheckCard(
                      isChecked: false,
                      isDisabled: _continueButtonController.isLoading,
                      onChanged: (checked) {},
                      textFragments: [
                        TextFragment(text: 'I want to receive product & marketing updates from Ivory. (Optional)')
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ListenableBuilder(
                      listenable: _continueButtonController,
                      builder: (context, child) {
                        return PrimaryButton(
                          text: "Continue",
                          isLoading: _continueButtonController.isLoading,
                          onPressed: _continueButtonController.isEnabled
                              ? () {
                                  _continueButtonController.setLoading();

                                  Navigator.pushNamed(context, OnboardingErrorEmailScreen.routeName);
                                }
                              : null,
                        );
                      },
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

  void _isSelected() {
    if (checkCardsValues.contains(false)) {
      _continueButtonController.setDisabled();
    } else {
      _continueButtonController.setEnabled();
    }
  }
}

class CheckCard extends StatelessWidget {
  final bool isChecked;
  final Function onChanged;
  final List<TextFragment> textFragments;
  final bool isDisabled;

  const CheckCard({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.textFragments,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ClientConfig.getCustomColors().neutral100,
        border: Border.all(
          color: ClientConfig.getCustomColors().neutral200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxWidget(
            isChecked: isChecked,
            isDisabled: isDisabled,
            onChanged: (value) => onChanged(value),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                children: [
                  for (final textFragment in textFragments)
                    TextSpan(
                      text: textFragment.text,
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: textFragment.filePath != null ? const Color(0xFF406FE6) : null,
                          ),
                      recognizer: (textFragment.filePath != null)
                          ? (TapGestureRecognizer()..onTap = () => _launchFileInBrowser(textFragment.filePath!))
                          : null,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchFileInBrowser(String filePath) async {
  final url = Uri(
    scheme: 'https',
    host: 'www.solarisgroup.com',
    path: filePath,
  );
  final requestFile = await launchUrl(url, mode: LaunchMode.externalApplication);

  if (!requestFile) {
    throw Exception('Could not launch $filePath');
  }
}

List<TextFragment> firstCardTextFragments = [
  TextFragment(text: 'I accept the '),
  TextFragment(
    text: 'General Terms & Conditions',
    filePath: '/customer-information/germany/de-iban/english/general-terms-and-conditions',
  ),
  TextFragment(text: ', the '),
  TextFragment(
    text: 'List of Prices and Services ',
    filePath: '/customer-information/germany/de-iban/english/list-of-prices-and-services',
  ),
  TextFragment(text: 'and '),
  TextFragment(
    text: 'all other conditions of Ivory.',
    filePath: '/customer-information/germany/de-iban/english/special-conditions-for-credit-cards',
  ),
];

List<TextFragment> secondCardTextFragments = [
  TextFragment(text: 'I agree to the '),
  TextFragment(text: 'Bureau Score Assessment T&Cs', filePath: '/'),
  TextFragment(text: '.'),
];

List<TextFragment> thirdCardTextFragments = [
  TextFragment(text: 'I agree to the '),
  TextFragment(text: 'Data Processing, Privacy Terms and General Data Protection Regulation (GDPR)', filePath: '/'),
  TextFragment(text: '.'),
];

class TextFragment {
  final String text;
  final String? filePath;

  TextFragment({
    required this.text,
    this.filePath,
  });
}
