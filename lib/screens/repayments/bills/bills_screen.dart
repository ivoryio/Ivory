import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bills_presenter.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import 'bill_detail_screen.dart';

class BillsScreen extends StatelessWidget {
  static const routeName = "/repaymentsBills";

  const BillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;
    final scrollController = ScrollController();

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            title: "Bills",
            scrollController: scrollController,
            titleMaxOpacityScrollOffset: 40,
            includeBottomScreenTitle: true,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            children: const [
              IvoryTextField(
                placeholder: 'Search by date',
                prefix: Icon(Icons.search),
              ),
              SizedBox(height: 16),
            ],
          ),
          StoreConnector<AppState, BillsViewModel>(
            onInit: (store) {
              store.dispatch(GetBillsCommandAction(user: user.cognito));
            },
            converter: (store) => BillsPresenter.presentBills(billState: store.state.billsState),
            distinct: true,
            builder: (context, viewModel) {
              if (viewModel is BillsLoadingViewModel || viewModel is BillsInitialViewModel) {
                return Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const CircularProgressIndicator(),
                );
              } else if (viewModel is BillsErrorViewModel) {
                return Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: const IvoryErrorWidget('Error loading bills'),
                );
              }

              final bills = (viewModel as BillsFetchedViewModel).bills;

              if (bills.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No bills yet', style: ClientConfig.getTextStyleScheme().heading4),
                    const SizedBox(height: 16),
                    Text(
                      'Your future bills will be displayed here after your automatic repayments go through.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    )
                  ],
                );
              }

              return Expanded(
                child: _BillsScrollView(
                  bills: bills,
                  scrollController: scrollController,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _BillsScrollView extends StatelessWidget {
  final List<Bill> bills;
  final ScrollController scrollController;
  const _BillsScrollView({required this.bills, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final billsGroupedByYear = <String, List<Bill>>{};
    for (var bill in bills) {
      final year = bill.statementDate.year.toString();
      if (billsGroupedByYear.containsKey(year)) {
        billsGroupedByYear[year]!.add(bill);
      } else {
        billsGroupedByYear[year] = [bill];
      }
    }

    return ListView.builder(
      controller: scrollController,
      padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
      itemCount: billsGroupedByYear.length,
      itemBuilder: (context, i) {
        final year = billsGroupedByYear.keys.elementAt(i);
        final bills = billsGroupedByYear[year]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              year,
              style: ClientConfig.getTextStyleScheme().heading4,
            ),
            const SizedBox(height: 8),
            ...bills.map((bill) => _BillItem(bill: bill)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _BillItem extends StatelessWidget {
  final Bill bill;
  const _BillItem({required this.bill});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        Format.date(bill.statementDate, pattern: 'MMM d, yyyy'),
        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
      minLeadingWidth: 0,
      leading: Icon(
        Icons.receipt_outlined,
        color: ClientConfig.getColorScheme().secondary,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: ClientConfig.getColorScheme().secondary,
      ),
      contentPadding: EdgeInsets.zero,
      onTap: () => Navigator.of(context).pushNamed(
        BillDetailScreen.routeName,
        arguments: bill.id,
      ),
    );
  }
}
