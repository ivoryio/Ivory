import 'package:flutter/widgets.dart';

import 'platform_currency_input.dart';

class AmountInformation extends StatefulWidget {
  final double? amount;

  const AmountInformation({super.key, this.amount});

  @override
  State<AmountInformation> createState() => AmountInformationState();
}

class AmountInformationState extends State<AmountInformation> {
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = widget.amount?.toString() ?? '';
  }

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