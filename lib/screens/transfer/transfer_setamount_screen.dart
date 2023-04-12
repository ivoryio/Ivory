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
            if (amount != null) {
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
                amountController: amountController,
              )
            ]),
      ),
    );
  }
}

class AmountInformation extends StatelessWidget {
  final TextEditingController? amountController;

  const AmountInformation({
    super.key,
    this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Enter Amount:'),
        const SizedBox(height: 8),
        PlatformCurrencyInput(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
          controller: amountController,
        ),
      ],
    );
  }
}
