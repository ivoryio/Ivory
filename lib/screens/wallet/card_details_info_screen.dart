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
      title: 'Step 1 out of 4',
      backButtonIcon: const Icon(Icons.arrow_back, size: 24),
      centerTitle: true,
      hideAppBar: false,
      hideBackButton: false,
      hideBottomNavbar: true,
      trailingActions: [
        IconButton(
          icon: Image.asset('assets/icons/porsche_logo.png'),
          iconSize: 40,
          onPressed: () {},
        ),
      ],
      child: Padding(
        padding: defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: double.infinity, height: 3, color: Colors.red),
            SpacedColumn(
              space: 32,
              children: [
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
                  context
                      .read<BankCardDetailsCubit>()
                      .startPinSetup(state.card!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
