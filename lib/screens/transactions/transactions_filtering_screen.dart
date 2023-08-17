import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/transactions/transactions_action.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';
import '../../widgets/modal.dart';
import '../../widgets/pill_button.dart';
import 'modals/transaction_date_picker_popup.dart';

class TransactionsFilteringScreen extends StatefulWidget {
  static const routeName = "/transactionsFilteringScreen";

  final TransactionListFilter? transactionListFilter;

  const TransactionsFilteringScreen({
    super.key,
    this.transactionListFilter,
  });

  @override
  State<TransactionsFilteringScreen> createState() => _TransactionsFilteringScreenState();
}

class _TransactionsFilteringScreenState extends State<TransactionsFilteringScreen> {
  TransactionListFilter? transactionListFilter;
  bool valoare = false;

  @override
  void initState() {
    transactionListFilter = widget.transactionListFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isFilterSelected =
        transactionListFilter?.bookingDateMin != null || transactionListFilter?.bookingDateMax != null;

    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             AppToolbar(
              richTextTitle: RichText(
                  text: TextSpan(
                    text: "Filter",
                    style: ClientConfig.getTextStyleScheme().heading4,
                  ),
              ),
            ),
            Text(
              "By date",
              style: ClientConfig.getTextStyleScheme().labelLarge,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.today,
                  size: 24,
                  color: ClientConfig.getColorScheme().secondary,
                ),
                PillButton(
                  active:
                      transactionListFilter?.bookingDateMin != null || transactionListFilter?.bookingDateMax != null,
                  buttonText:
                      '${getFormattedDate(date: transactionListFilter?.bookingDateMin, text: "Start date")} - ${getFormattedDate(date: transactionListFilter?.bookingDateMax, text: "End date")}',
                  buttonCallback: () {
                    showBottomModal(
                      context: context,
                      showCloseButton: false,
                      content: TransactionDatePickerPopup(
                        initialSelectedRange: isFilterSelected
                            ? DateTimeRange(
                                start: transactionListFilter!.bookingDateMin!,
                                end: transactionListFilter!.bookingDateMax!)
                            : null,
                        onDateRangeSelected: (DateTimeRange range) {
                          setState(() {
                            transactionListFilter = TransactionListFilter(
                              bookingDateMin: range.start,
                              bookingDateMax: range.end,
                            );
                          });
                        },
                      ),
                    );
                  },
                  icon: (transactionListFilter?.bookingDateMin != null || transactionListFilter?.bookingDateMax != null)
                      ? const Icon(
                          Icons.close,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 36,),
            Text(
              "By category",
              style: ClientConfig.getTextStyleScheme().labelLarge,
            ),
            const SizedBox(height: 16,),
            Row(
              children: [
                CheckboxWidget(isChecked: valoare, onChanged: (bool? value){
                  setState(() {
                    valoare = value!;
                  });
                }),
                const SizedBox(width: 8,),
                Text(
                  "ATM",
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                      text: "Apply filters",
                      onPressed: () {
                        StoreProvider.of<AppState>(context)
                            .dispatch(GetTransactionsCommandAction(filter: transactionListFilter, user: user.cognito));

                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

String getFormattedDate({
  DateTime? date,
  String text = "Date not set",
}) {
  if (date == null) {
    return text;
  }

  return Format.date(date, pattern: "dd MMM yyyy");
}
