import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';

class BankCardDetailsConfirmPinScreen extends StatelessWidget {
  const BankCardDetailsConfirmPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'BankDetailsConfirmPinScreen',
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
                  'Confirm PIN',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                Text(
                  'Confirm your PIN by typing it again.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 10,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 24,
                    ),
                    Text(
                      'Your date of birth',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Your PIN should match",
                    onPressed: () {
                      context
                          .read<BankCardDetailsCubit>()
                          .successActivation(state.card!);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
