import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';

class BankCardDetailsActivationSuccessScreen extends StatelessWidget {
  const BankCardDetailsActivationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'BankDetailsActivationSuccessScreen',
      centerTitle: true,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 16,
              children: const [
                Text(
                  'Card successfully activated!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                Text(
                  'You can now start using your PIN to make in-store purchases, make withdrawals and more.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const BankCardWidget(
              cardNumber:
                  '0000 0000 0000 0000', // state.card!.representation!.maskedPan!,
              cardHolder:
                  'cardHolder', // state.card!.representation!.line2 ?? 'data missing',
              cardExpiry:
                  'cardExpiry', // state.card!.representation!.formattedExpirationDate!,
              isViewable: false,
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Back to "Card"',
                onPressed: () {
                  context.read<BankCardDetailsCubit>().backToCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
