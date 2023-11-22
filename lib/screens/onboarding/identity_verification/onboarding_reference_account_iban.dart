import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/identity_verification/onboarding_identity_verification_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/identity_verification/onboarding_identity_verification_action.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingReferenceAccountIbanScreen extends StatefulWidget {
  static const routeName = "/onboardingReferenceAccountIbanScreen";

  const OnboardingReferenceAccountIbanScreen({super.key});

  @override
  State<OnboardingReferenceAccountIbanScreen> createState() => _OnboardingReferenceAccountIbanScreenState();
}

class _OnboardingReferenceAccountIbanScreenState extends State<OnboardingReferenceAccountIbanScreen> {
  final IvoryTextFieldController _accountNameController = IvoryTextFieldController();
  final IvoryTextFieldController _accountIbanController = IvoryTextFieldController(text: 'DE11110101010100000020');
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();

    _continueButtonController.setDisabled();

    _accountNameController.addListener(_isValidated);
    _accountIbanController.addListener(_isValidated);
  }

  void _isValidated() {
    if (_accountNameController.text.isNotEmpty &&
        _accountIbanController.text == 'DE11110101010100000020' &&
        _isChecked == true) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingIdentityVerificationViewModel>(
      converter: (store) => OnboardingIdentityVerificationPresenter.present(
        identityVerificationState: store.state.onboardingIdentityVerificationState,
      ),
      distinct: true,
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isLoading) {
          _continueButtonController.setLoading();
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                richTextTitle: StepRichTextTitle(step: 3, totalSteps: 7),
                actions: const [AppbarLogo()],
              ),
              AnimatedLinearProgressIndicator.step(current: 3, totalSteps: 7),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Reference account IBAN', style: ClientConfig.getTextStyleScheme().heading2)),
                      const SizedBox(height: 24),
                      Text.rich(
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        TextSpan(
                          children: [
                            const TextSpan(text: 'Please provide the '),
                            TextSpan(text: 'IBAN', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: ' for your '),
                            TextSpan(
                              text: 'reference bank account',
                              style: ClientConfig.getTextStyleScheme()
                                  .bodyLargeRegularBold
                                  .copyWith(color: ClientConfig.getColorScheme().secondary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => showBottomModal(
                                      context: context,
                                      title: 'What is a reference account?',
                                      textWidget: Column(
                                        children: [
                                          for (final referenceAccountCheck in referenceAccountChecks) ...[
                                            _buildReferenceBankAccount(referenceAccountCheck),
                                            const SizedBox(height: 24),
                                          ]
                                        ],
                                      ),
                                    ),
                            ),
                            const TextSpan(text: '. In the following steps, you will need to enter your '),
                            TextSpan(
                                text: 'bank credentials',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: ', after which we will initiate a transfer of '),
                            TextSpan(text: '0.01€', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: ' from this account.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      IvoryTextField(
                        controller: _accountNameController,
                        label: 'Reference account name',
                        placeholder: 'Type reference account name',
                        inputFormatters: [
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            if (newValue.text.isEmpty || newValue.text.contains(RegExp(r'^[a-zA-Z0-9]+'))) {
                              return newValue;
                            }
                            return oldValue;
                          }),
                        ],
                      ),
                      const SizedBox(height: 24),
                      IvoryTextField(
                        controller: _accountIbanController,
                        label: 'Reference account IBAN',
                        placeholder: 'E.g. DE11110101010100000020',
                        onChanged: (value) {
                          if (value != 'DE11110101010100000020') {
                            _accountIbanController
                                .setErrorText('IBAN not found. Please try again with a different one.');
                          } else {
                            _accountIbanController.setErrorText(null);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),
                      ApprovePolicy(
                        isChecked: _isChecked,
                        isDisabled: _continueButtonController.isLoading,
                        onChanged: (checked) {
                          setState(() {
                            _isChecked = checked;
                            _isValidated();
                          });
                        },
                        message: Text.rich(
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          TextSpan(
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                  text: 'Swisscom\'s Terms & Conditions',
                                  style: ClientConfig.getTextStyleScheme()
                                      .bodyLargeRegularBold
                                      .copyWith(color: ClientConfig.getColorScheme().secondary)),
                              const TextSpan(text: '.'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => PrimaryButton(
                            text: "Continue to verification",
                            isLoading: _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      CreateUrlForIntegrationCommandAction(
                                        accountName: _accountNameController.text,
                                        iban: _accountIbanController.text,
                                      ),
                                    );

                                    // Navigator.of(context).pushNamed(NextScreen.routeName);
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

  Widget _buildReferenceBankAccount(InlineSpan referenceAccountCheck) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(
            'assets/icons/check_icon.svg',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text.rich(
            style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            referenceAccountCheck,
          ),
        ),
      ],
    );
  }
}

class ApprovePolicy extends StatelessWidget {
  final bool isChecked;
  final Function onChanged;
  final Widget message;
  final bool isDisabled;

  const ApprovePolicy({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.message,
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
            child: message,
          ),
        ],
      ),
    );
  }
}

List<InlineSpan> referenceAccountChecks = [
  TextSpan(
    children: [
      const TextSpan(text: 'Your reference account is the '),
      TextSpan(
        text: 'designated bank account from which we will deduct repayments',
        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      const TextSpan(text: ' during each credit cycle.'),
    ],
  ),
  TextSpan(
    children: [
      const TextSpan(text: 'It\'s essential to ensure that your reference account has '),
      TextSpan(
        text: 'sufficient funds available',
        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      const TextSpan(text: '.'),
    ],
  ),
  TextSpan(
    children: [
      const TextSpan(text: 'Please note that changing your default account for automatic deductions '),
      TextSpan(
        text: 'will require a call to our support team',
        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      const TextSpan(text: '.'),
    ],
  ),
];
