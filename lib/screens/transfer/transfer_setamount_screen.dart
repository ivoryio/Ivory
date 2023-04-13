import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/transfer/transfer_cubit.dart';
import '../../router/routing_constants.dart';
import '../../themes/default_theme.dart';
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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController amountController = TextEditingController(
        text: state.amount != null ? state.amount.toString() : "");

    return Screen(
      customBackButtonCallback: () {
        context.read<TransferCubit>().setInitState(
              name: state.name,
              iban: state.iban,
              savePayee: state.savePayee,
            );
      },
      title: transferRoute.title,
      hideBottomNavbar: true,
      bottomStickyWidget: BottomStickyWidget(
        child: StickyBottomContent(
          buttonText: "Send money",
          onContinueCallback: () {
            final amount = double.tryParse(amountController.text);
            if (formKey.currentState!.validate()) {
              context.read<TransferCubit>().setAmount(amount: amount);
            }
          },
        ),
      ),
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AmountInformation(
                formKey: formKey,
                amountController: amountController,
              )
            ]),
      ),
    );
  }
}

class AmountInformation extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;

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
                print("error");
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
