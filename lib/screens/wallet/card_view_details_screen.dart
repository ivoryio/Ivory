import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/card_details_widget.dart';
import '../../widgets/circular_countdown_progress_widget.dart';
import '../../widgets/screen.dart';

class BankCardViewDetailsScreen extends StatelessWidget {
  const BankCardViewDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'View card details',
      titleTextStyle: const TextStyle(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w600,
      ),
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                BankCardShowDetailsWidget(
                  cardNumber: '4957 3648 3747 4573',
                  cardCvv: '362',
                  cardExpiry: '10/27',
                  cardType: 'Physical card',
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'This information will be displayed for 60 seconds.',
                        style: TextStyle(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0.0),
                      child: const CircularCountdownProgress(),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Back to "Card"',
                    onPressed: () {
                      context
                          .read<BankCardDetailsCubit>()
                          .goToCardDetails(state.card!);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
