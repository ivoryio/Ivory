import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class BankCardDetailsChoosePinScreen extends StatelessWidget {
  const BankCardDetailsChoosePinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'BankDetailsChoosePinScreen',
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
              space: 32,
              children: [
                const Text('BankDetailsChoosePinScreen'),
                SpacedColumn(
                  space: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Choose PIN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'Remember your PIN as you will use it for all future card purchases.',
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
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 10,
              children: [
                const Text(
                  'Your PIN should not contain:',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 0,
                  children: const [
                    Row(
                      children: [
                        Icon(
                          Icons.close,
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
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'Your postal code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'Number sequences, e.g. 1234',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.close,
                          size: 24,
                        ),
                        Text(
                          'More than two digits repeating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Insert 4 digit for PIN",
                    onPressed: () {
                      // context.read<BankCardDetailsCubit>().initializeActivation();
                      context
                          .read<BankCardDetailsCubit>()
                          .confirmPIN(state.card!);
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
