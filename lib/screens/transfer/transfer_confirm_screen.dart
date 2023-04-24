import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

import '../../cubits/transfer/transfer_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/account_select.dart';
import '../../widgets/screen.dart';
import '../../widgets/sticky_bottom_content.dart';
import '../../widgets/text_currency_value.dart';

class TransferConfirmScreen extends StatelessWidget {
  final TransferConfirmState state;
  const TransferConfirmScreen({
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
      bottomStickyWidget: BottomStickyWidget(
        child: StickyBottomContent(
          buttonText: "Confirm and send",
          onContinueCallback: () {
            context.read<TransferCubit>().confirmTransfer(
                  name: state.name,
                  iban: state.iban,
                  description: state.description,
                  savePayee: state.savePayee,
                  amount: state.amount,
                );
          },
        ),
      ),
      child: Padding(
        padding: defaultScreenPadding,
        child: SpacedColumn(
          space: 32,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AccountSelect(),
            TransferDetails(
              iban: state.iban!,
              amount: state.amount!,
              name: state.name!,
              description: state.description!,
            ),
          ],
        ),
      ),
    );
  }
}

class TransferDetails extends StatelessWidget {
  final String iban;
  final String name;
  final String description;
  final double amount;
  const TransferDetails({
    super.key,
    required this.iban,
    required this.name,
    required this.description,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      space: 24,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transfer details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payee",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              iban,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            TextCurrencyValue(
              value: amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SpacedColumn(
          space: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Fee",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF667085),
              ),
            ),
            TextCurrencyValue(
              value: 0,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ],
    );
  }
}
