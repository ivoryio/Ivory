import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../widgets/button.dart';
import '../../widgets/screen.dart';

class BankCardDetailsInfoScreen extends StatelessWidget {
  const BankCardDetailsInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'BankDetailsInfoScreen',
      child: SpacedColumn(
        space: 32,
        children: [
          const Text('BankDetailsInfoScreen'),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              text: "Next",
              onPressed: () {
                // context.read<BankCardDetailsCubit>().initializeActivation();
              },
            ),
          ),
        ],
      ),
    );
  }
}
