import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../config.dart';
import '../../cubits/transfer/transfer_cubit.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/tan_input.dart';

class TransferConfirmTanScreen extends StatelessWidget {
  final TransferConfirmTanState state;
  const TransferConfirmTanScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      customBackButtonCallback: () {
        context.read<TransferCubit>().setBasicData(
              name: state.name,
              iban: state.iban,
              amount: state.amount,
              savePayee: state.savePayee,
              description: state.description,
            );
      },
      title: "Transaction confirmation",
      hideBottomNavbar: true,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: SpacedColumn(
          space: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please enter the TAN you received via SMS. (TAN: ${state.token})",
            ),
            TanInput(
              length: 6,
              onCompleted: (String tan) {
                context.read<TransferCubit>().confirmTan(tan);
              },
            ),
          ],
        ),
      ),
    );
  }
}
