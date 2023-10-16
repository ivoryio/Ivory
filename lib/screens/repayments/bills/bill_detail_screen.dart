import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_detail_presenter.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/expanded_details_row.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/spaced_column.dart';

class BillDetailScreen extends StatelessWidget {
  static const routeName = "/repaymentsBillDetail";

  const BillDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final billId = ModalRoute.of(context)!.settings.arguments as String;
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;
    final scrollController = ScrollController();

    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            title: "Bill details",
            scrollController: scrollController,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: StoreConnector<AppState, BillDetailViewModel>(
                onInit: (store) {
                  store.dispatch(GetBillByIdCommandAction(id: billId, user: user.cognito));
                },
                converter: (store) => BillDetailPresenter.presentBillDetail(
                  billState: store.state.billsState,
                  billId: billId,
                ),
                distinct: true,
                builder: (context, viewModel) {
                  final bill = viewModel.bill;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                  Text('Repayment details',
                                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                                  if (viewModel.transactionsLoaded) ...[
                                    ExpandedDetailsRow(
                                      title: 'Amount spent',
                                      trailing: Format.euro(bill.amountSpent!.value),
                                    ),
                                    ...bill.transactions!.map(
                                      (transaction) => Padding(
                                        padding: EdgeInsets.only(
                                            left: ClientConfig.getCustomClientUiSettings().defaultScreenLeftPadding),
                                        child: ExpandedDetailsRow(
                                          title: transaction.merchantName,
                                          trailing: Format.euro(transaction.amount.value),
                                        ),
                                      ),
                                    )
                                  ] else
                                    const Center(
                                      child: SizedBox.square(
                                        dimension: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  ExpandedDetailsRow(
                                    title: 'Fixed repayment rate',
                                    trailing: Format.euro(bill.currentBillAmount.value),
                                  ),
                                  ExpandedDetailsRow(title: 'Interest rate', trailing: '${bill.interestRate}%'),
                                  ExpandedDetailsRow(
                                    title: 'Interest amount',
                                    trailing: Format.euro(bill.currentBillAmount.value),
                                  ),
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
                                    title: 'Total repayment amount',
                                    trailing: Format.euro(bill.currentBillAmount.value),
                                  ),
                                  ExpandedDetailsRow(
                                    title: 'Due date',
                                    trailing: Format.date(bill.dueDate, pattern: 'MMM d, yyyy'),
                                  ),
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
                              Text('Outstanding balance',
                                  style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                              ExpandedDetailsRow(
                                title: 'Before repayment',
                                trailing: Format.euro(bill.outstandingAmount.value),
                              ),
                              ExpandedDetailsRow(
                                title: 'After repaymeny',
                                trailing: Format.euro(bill.outstandingAmount.value - bill.currentBillAmount.value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Actions', style: ClientConfig.getTextStyleScheme().heading4),
                      const SizedBox(height: 8),
                      _DownloadBillButton(bill: bill),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadBillButton extends StatefulWidget {
  final Bill bill;
  const _DownloadBillButton({required this.bill});

  @override
  State<_DownloadBillButton> createState() => _DownloadBillButtonState();
}

class _DownloadBillButtonState extends State<_DownloadBillButton> {
  bool _isLoading = false;

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
      trailing: _isLoading
          ? const SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
      contentPadding: EdgeInsets.zero,
      onTap: () {
        setState(() => _isLoading = true);
        StoreProvider.of<AppState>(context).dispatch(
          DownloadBillCommandAction(
            bill: widget.bill,
            onDownloaded: () {
              if (!mounted) return;
              setState(() => _isLoading = false);
            },
          ),
        );
      },
    );
  }
}
