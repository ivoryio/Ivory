import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/transfer/transfer_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/screen.dart';
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
              savePayee: state.savePayee,
              amount: state.amount,
            );
      },
      title: "Transaction confirmation",
      hideBottomNavbar: true,
      child: Center(
        child: Padding(
          padding: defaultScreenPadding,
          child: TanInput(
            length: 6,
            onCompleted: (String tan) {
              context.read<TransferCubit>().confirmTan(tan);
            },
          ),
        ),
      ),
    );
  }
}
