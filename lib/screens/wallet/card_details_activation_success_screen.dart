import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';

class BankCardDetailsActivationSuccessScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsActivationSuccessScreen';

  const BankCardDetailsActivationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: '',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: true,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
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
            BankCardWidget(
              cardNumber: state.card!.representation!.maskedPan ?? '',
              cardHolder: state.card!.representation!.line2 ?? '',
              cardExpiry:
                  state.card!.representation!.formattedExpirationDate ?? '',
              isViewable: false,
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Back to "Card"',
                onPressed: () {
                  context.read<BankCardDetailsCubit>().loadCard(state.card!.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
