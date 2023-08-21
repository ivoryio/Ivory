import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bills_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_error_widget.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BillsScreen extends StatelessWidget {
  static const routeName = "/repaymentsBills";

  const BillsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            Text(
              'Bills',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 24),
            const IvoryTextField(
              placeholder: 'Search by date',
              prefix: Icon(Icons.search),
            ),
            const SizedBox(height: 24),
            StoreConnector<AppState, BillsViewModel>(
              onInit: (store) {
                store.dispatch(GetBillsCommandAction(user: user.cognito));
              },
              converter: (store) => BillsPresenter.presentBills(
                billState: store.state.billsState,
                user: user,
              ),
              distinct: true,
              builder: (context, viewModel) {
                if (viewModel is BillsLoadingViewModel) {
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

                return const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
