import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/screens/onboarding/financial_details/onboarding_public_status_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingTaxIdScreen extends StatefulWidget {
  static const routeName = '/onboardingTaxIDScreen';

  const OnboardingTaxIdScreen({super.key});

  @override
  State<OnboardingTaxIdScreen> createState() => _OnboardingTaxIdScreenState();
}

class _OnboardingTaxIdScreenState extends State<OnboardingTaxIdScreen> {
  final IvoryTextFieldController _taxIdController = IvoryTextFieldController(text: '489 543 712 07');
  final ContinueButtonController _continueButtonController = ContinueButtonController();

  @override
  void initState() {
    super.initState();

    isValidTaxId(_taxIdController.text);

    _taxIdController.addListener(() {
      setState(() {
        isValidTaxId(_taxIdController.text);
      });
    });
  }

  isValidTaxId(String text) {
    text = text.replaceAll(' ', '');
    text.isNotEmpty ? _continueButtonController.setEnabled() : _continueButtonController.setDisabled();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            richTextTitle: StepRichTextTitle(step: 2, totalSteps: 5),
            actions: const [AppbarLogo()],
          ),
          AnimatedLinearProgressIndicator.step(current: 2, totalSteps: 5),
          Expanded(
            child: ScrollableScreenContainer(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Tax ID', style: ClientConfig.getTextStyleScheme().heading2)),
                  const SizedBox(height: 16),
                  IvoryTextField(
                    label: 'Tax ID number',
                    controller: _taxIdController,
                    inputFormatters: [InputFormatter.taxId(_taxIdController.text)],
                    inputType: TextFieldInputType.number,
                    keyboardType: TextInputType.number,
                    placeholder: '489 543 712 07',
                  ),
                  const Spacer(),
                  StoreConnector<AppState, OnboardingFinancialDetailsViewModel>(
                    converter: (store) => OnboardingFinancialDetailsPresenter.present(
                        financialState: store.state.onboardingFinancialDetailsState),
                    onWillChange: (previousViewModel, newViewModel) {
                      if (newViewModel.isLoading) {
                        _continueButtonController.setLoading();
                      } else if (previousViewModel!.financialDetailsAttributes.taxId == null &&
                          newViewModel.financialDetailsAttributes.taxId != null) {
                        Navigator.pushNamed(context, OnboardingPublicStatusScreen.routeName);
                      } else if (newViewModel.errorType != null) {
                        _taxIdController.setErrorText('This Tax ID is invalid for Germany. Please try another.');
                      }
                    },
                    distinct: true,
                    builder: (context, viewModel) {
                      return SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          text: "Continue",
                          isLoading: _continueButtonController.isLoading,
                          onPressed: _continueButtonController.isEnabled
                              ? () => StoreProvider.of<AppState>(context)
                                  .dispatch(CreateTaxIdCommandAction(taxId: _taxIdController.text.replaceAll(' ', '')))
                              : null,
                        ),
                      );
                    },
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
