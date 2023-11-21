import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/onboarding/financial_details/onboarding_financial_details_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/onboarding/financial_details/onboarding_financial_details_action.dart';
import 'package:solarisdemo/screens/onboarding/onboarding_stepper_screen.dart';
import 'package:solarisdemo/widgets/animated_linear_progress_indicator.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/ivory_currency_field.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

class OnboardingMonthlyIncomeScreen extends StatefulWidget {
  static const routeName = '/onboardingMonthlyIncomeScreen';
  const OnboardingMonthlyIncomeScreen({super.key});

  @override
  State<OnboardingMonthlyIncomeScreen> createState() => _OnboardingMonthlyIncomeScreenState();
}

class _OnboardingMonthlyIncomeScreenState extends State<OnboardingMonthlyIncomeScreen> {
  final ContinueButtonController _continueButtonController = ContinueButtonController();
  final TextEditingController _monthlyIncomeController = TextEditingController();
  final TextEditingController _monthlyExpenseController = TextEditingController();
  final TextEditingController _totalCurrentDebtController = TextEditingController();
  final TextEditingController _totalCreditLimitController = TextEditingController();

  void onChange() {
    final hasValues = _monthlyIncomeController.text.isNotEmpty &&
        _monthlyExpenseController.text.isNotEmpty &&
        _totalCurrentDebtController.text.isNotEmpty &&
        _totalCreditLimitController.text.isNotEmpty;

    if (hasValues) {
      _continueButtonController.setEnabled();
    } else {
      _continueButtonController.setDisabled();
    }
  }

  @override
  void initState() {
    _monthlyIncomeController.addListener(onChange);
    _monthlyExpenseController.addListener(onChange);
    _totalCurrentDebtController.addListener(onChange);
    _totalCreditLimitController.addListener(onChange);
    super.initState();
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _monthlyExpenseController.dispose();
    _totalCurrentDebtController.dispose();
    _totalCreditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingFinancialDetailsViewModel>(
      converter: (store) => OnboardingFinancialDetailsPresenter.present(
        financialState: store.state.onboardingFinancialDetailsState,
      ),
      onWillChange: (previousViewModel, newViewModel) {
        if (newViewModel.isLoading) {
          _continueButtonController.setLoading();
        }
        if (newViewModel.isCreditCardApplicationCreated == true) {
          Navigator.pushNamedAndRemoveUntil(context, OnboardingStepperScreen.routeName, (route) => false);
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            children: [
              AppToolbar(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                richTextTitle: StepRichTextTitle(
                  step: 5,
                  totalSteps: 5,
                ),
                actions: const [
                  AppbarLogo(),
                ],
                onBackButtonPressed: () {},
                backButtonEnabled: true,
              ),
              AnimatedLinearProgressIndicator.step(
                current: 5,
                totalSteps: 5,
              ),
              Expanded(
                child: ScrollableScreenContainer(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                            Text('Income, expenses & other\ncredit', style: ClientConfig.getTextStyleScheme().heading2),
                      ),
                      const SizedBox(height: 24),
                      InputCurrencyField(
                        controller: _monthlyIncomeController,
                        currencyPathIcon: 'assets/icons/euro_icon.svg',
                        label: 'Monthly income',
                      ),
                      const SizedBox(height: 24),
                      InputCurrencyField(
                        controller: _monthlyExpenseController,
                        currencyPathIcon: 'assets/icons/euro_icon.svg',
                        label: 'Monthly expenses',
                      ),
                      const SizedBox(height: 24),
                      InputCurrencyField(
                        controller: _totalCurrentDebtController,
                        currencyPathIcon: 'assets/icons/euro_icon.svg',
                        label: 'Total current debt',
                        labelSuffix: InkWell(
                          onTap: () => _showModalTotalCurrentDebt(),
                          child: Icon(
                            Icons.info_outline,
                            color: ClientConfig.getCustomColors().neutral700,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      InputCurrencyField(
                        controller: _totalCreditLimitController,
                        currencyPathIcon: 'assets/icons/euro_icon.svg',
                        label: 'Total credit limit',
                        labelSuffix: InkWell(
                          onTap: () => _showModalTotalCreditLimit(),
                          child: Icon(
                            Icons.info_outline,
                            color: ClientConfig.getCustomColors().neutral700,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Spacer(),
                      ListenableBuilder(
                        listenable: _continueButtonController,
                        builder: (context, child) => PrimaryButton(
                            text: "Continue",
                            isLoading: _continueButtonController.isLoading,
                            onPressed: _continueButtonController.isEnabled
                                ? () {
                                    StoreProvider.of<AppState>(context).dispatch(
                                      CreateCreditCardApplicationCommandAction(
                                        monthlyExpense: num.parse(_monthlyExpenseController.text.replaceAll(',', '')),
                                        monthlyIncome: num.parse(_monthlyIncomeController.text.replaceAll(',', '')),
                                        totalCreditLimit:
                                            num.parse(_totalCreditLimitController.text.replaceAll(',', '')),
                                        totalCurrentDebt:
                                            num.parse(_totalCurrentDebtController.text.replaceAll(',', '')),
                                      ),
                                    );
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

  void _showModalTotalCurrentDebt() {
    showBottomModal(
      context: context,
      title: 'Total current debt',
      content: Text.rich(
        TextSpan(
          style: ClientConfig.getTextStyleScheme().mixedStyles,
          children: [
            const TextSpan(
              text: '\'Total current debt\' refers to the ',
            ),
            TextSpan(
              text:
                  'combined amount of your outstanding financial obligations, such as credit card balances, loans, or any other debts you currently owe. ',
              style: ClientConfig.getTextStyleScheme().mixedStyles.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const TextSpan(
              text:
                  'Accurate information about your current debt helps us better understand your financial situation and tailor our credit card offerings to your needs.',
            ),
          ],
        ),
      ),
    );
  }

  void _showModalTotalCreditLimit() {
    showBottomModal(
      context: context,
      title: 'Total credit limit',
      content: Text.rich(
        TextSpan(
          style: ClientConfig.getTextStyleScheme().mixedStyles,
          children: [
            const TextSpan(
              text: '\'Total credit limit\' is the ',
            ),
            TextSpan(
              text:
                  'total maximum amount of credit available to you across all your credit cards and credit accounts. ',
              style: ClientConfig.getTextStyleScheme().mixedStyles.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const TextSpan(
              text:
                  'It\'s crucial for us to know this amount to ensure we offer you the most suitable credit card products.',
            ),
          ],
        ),
      ),
    );
  }
}
