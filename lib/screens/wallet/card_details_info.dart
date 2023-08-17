import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../config.dart';
import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class BankCardDetailsInfoScreen extends StatelessWidget {
  static const routeName = '/cardDetailsInfoScreen';

  const BankCardDetailsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return Padding(
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SpacedColumn(
            space: 32,
            children: [
              SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                space: 16,
                children: const [
                  Text(
                    'Activate your physical card',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                    ),
                  ),
                  Text(
                    'In order to activate your physical card you will have to choose a PIN and confirm it. You can also add it to your Apple Wallet. \n\nIt\'ll take only 1 minute.',
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
                context.read<BankCardDetailsCubit>().startPinSetup(state.card!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
