import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';
import 'package:solarisdemo/screens/repayments/repayments_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

class BillDetailScreen extends StatelessWidget {
  static const routeName = "/repaymentsBillDetail";

  const BillDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bill = ModalRoute.of(context)!.settings.arguments as Bill;

    return ScreenScaffold(
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text(
              Format.date(bill.statementDate, pattern: 'MMM d, yyyy'),
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 24),
            Material(
              color: const Color(0xFFF8F9FA),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      space: 8,
                      children: [
                        Text('Repayment details', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        ExpandedDetailsRow(
                          title: 'Amount spent',
                          trailing: '- ${Format.euro(bill.outstandingAmount.value)}',
                        ),
                        ExpandedDetailsRow(title: 'Fixed repayment rate', trailing: '500'),
                        ExpandedDetailsRow(title: 'Interest rate', trailing: '500'),
                        ExpandedDetailsRow(title: 'Interest amount', trailing: '500'),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SpacedColumn(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      space: 8,
                      children: [
                        ExpandedDetailsRow(
                            title: 'Total repayment amount', trailing: Format.euro(bill.totalOutstandingAmount.value)),
                        ExpandedDetailsRow(
                            title: 'Due date', trailing: Format.date(bill.dueDate, pattern: 'MMM d, yyyy')),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            Material(
              color: const Color(0xFFF8F9FA),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 8,
                  children: [
                    Text('Outstanding balance', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                    ExpandedDetailsRow(
                      title: 'Before repayment',
                      trailing: Format.euro(bill.prevBillAmount.value),
                    ),
                    ExpandedDetailsRow(title: 'After repaymeny', trailing: Format.euro(bill.currentBillAmount.value)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Actions', style: ClientConfig.getTextStyleScheme().heading4),
            const SizedBox(height: 8),
            _DownloadBillButton(bill: bill),
          ],
        ),
      ),
    );
  }
}

class _DownloadBillButton extends StatelessWidget {
  final Bill bill;
  const _DownloadBillButton({required this.bill});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Download bill',
        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      subtitle: Text(
        'Locally in .pdf format',
        style: ClientConfig.getTextStyleScheme().bodySmallRegular,
      ),
      minLeadingWidth: 0,
      leading: SizedBox(
        height: double.infinity,
        child: Icon(
          Icons.download_outlined,
          color: ClientConfig.getColorScheme().secondary,
        ),
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () {
        StoreProvider.of<AppState>(context).dispatch(DownloadBillCommandAction(bill: bill));
      },
    );
  }
}
