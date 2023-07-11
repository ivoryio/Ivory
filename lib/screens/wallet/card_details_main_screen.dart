import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class CardDetailsMainScreen extends StatelessWidget {
  const CardDetailsMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'Card',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: false,
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              space: 48,
              children: [
                BankCardWidget(
                  cardNumber: state.card!.representation!.maskedPan!,
                  cardHolder:
                      state.card!.representation!.line2 ?? 'data missing',
                  cardExpiry:
                      state.card!.representation!.formattedExpirationDate!,
                  isViewable: false,
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 16,
                  children: const [
                    Text(
                      'Activate your card',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'Your card is currently inactive. \n\nOnce it arrives to your address, click on the "Activate my card" to active it and start using. \n\nIt will take only 1 minute.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Activate my card",
                onPressed: () {
                  context.read<BankCardDetailsCubit>().initializeActivation();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
