import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class BankCardDetailsInfoScreen extends StatelessWidget {
  const BankCardDetailsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'BankDetailsInfoScreen',
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
                const Text('BankDetailsInfoScreen'),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 16,
                  children: const [
                    Text(
                      'Let\'s activate your card',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        height: 1.33,
                      ),
                    ),
                    Text(
                      'In order to activate your card you will have to choose a PIN and confirm it. \n\n It\'ll take only 1 minute.',
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
            Expanded(
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/choose_pin.svg',
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Choose PIN",
                onPressed: () {
                  context.read<BankCardDetailsCubit>().choosePin(state.card!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
