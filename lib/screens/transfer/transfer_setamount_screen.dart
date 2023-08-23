import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/transfer/transfer_cubit.dart';
import '../../utilities/constants.dart';
import '../../utilities/currency_text_field_controller.dart';
import '../../utilities/format.dart';
import '../../widgets/platform_currency_input.dart';
import '../../widgets/screen.dart';
import '../../widgets/sticky_bottom_content.dart';

class TransferSetAmountScreen extends StatelessWidget {
  final TransferSetAmountState state;

  const TransferSetAmountScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    String currency =
        context.read<AuthCubit>().state.user?.personAccount.balance?.currency ??
            defaultCurrency;

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final CurrencyTextFieldController amountController =
        CurrencyTextFieldController(
      currencySymbol: Format.getCurrencySymbol(currency),
      initDoubleValue: state.amount,
    );
    final GlobalKey<StickyBottomContentState> stickyBottomContentKey =
        GlobalKey();

    void changeListener() {
      bool buttonActive = stickyBottomContentKey.currentState!.buttonActive;

      if (!buttonActive && amountController.text.isNotEmpty) {
        stickyBottomContentKey.currentState!.setButtonEnabled();
      }
      if (buttonActive && !amountController.text.isNotEmpty) {
        stickyBottomContentKey.currentState!.setButtonDisabled();
      }
    }

    amountController.addListener(changeListener);

    return ScreenScaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AppToolbar(
              title: "Transfer",
              onBackButtonPressed: () {
                context.read<TransferCubit>().setInitState(
                      name: state.name,
                      iban: state.iban,
                      savePayee: state.savePayee,
                      description: state.description,
                    );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AmountInformation(
              formKey: formKey,
              amountController: amountController,
            ),
          ),
          const Spacer(),
          BottomStickyWidget(
            child: StickyBottomContent(
              key: stickyBottomContentKey,
              buttonActive: state.amount != null,
              buttonText: "Send money",
              onContinueCallback: () {
                final amount = amountController.doubleValue;
                if (formKey.currentState!.validate()) {
                  context.read<TransferCubit>().setAmount(amount: amount);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AmountInformation extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CurrencyTextFieldController amountController;

  const AmountInformation({
    super.key,
    required this.formKey,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Enter Amount:'),
          const SizedBox(height: 8),
          PlatformCurrencyInput(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              return null;
            },
            controller: amountController,
          ),
        ],
      ),
    );
  }
}
