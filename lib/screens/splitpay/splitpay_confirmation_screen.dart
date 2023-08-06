import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/splitpay_cubit/splitpay_cubit.dart';
import '../../models/transaction_model.dart';
import '../../utilities/format.dart';
import '../../widgets/button.dart';
import '../../widgets/checkbox.dart';
import '../../widgets/dialog.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/transaction_listing_item.dart';

class SplitpayConfirmationScreen extends StatelessWidget {
  static const routeName = '/splitpayConfirmationScreen';

  final Transaction transaction;

  const SplitpayConfirmationScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final String currencySymbol =
        Format.getCurrencySymbol(transaction.amount!.currency!);

    final state = context.read<SplitpayCubit>().state;
    final formattedMonth = DateFormat('MMM').format(
      DateTime.parse(transaction.bookingDate!),
    );
    final formattedDay = DateFormat('dd').format(
      DateTime.parse(transaction.bookingDate!),
    );

    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            AppToolbar(title: 'Transaction confirmation'),
            Expanded(
              child: Column(
                children: [
                  SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    space: 24,
                    children: [
                      Text(
                        '$currencySymbol ${transaction.amount!.value!.abs()} ${transaction.recipientName} purchase into monthly instalments from your limit of € 8000',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(
                            0xFF6A6A6A,
                          ),
                        ),
                      ),
                      const Text(
                        'Transaction details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TransactionListItem(
                        transaction: transaction,
                        isClickable: false,
                      ),
                      SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        space: 8,
                        children: [
                          const Text(
                            'Total Amount Payable',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xFF667085,
                              ),
                            ),
                          ),
                          Text(
                            '$currencySymbol ${state.splitpayInfo!.totalAmount}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        space: 8,
                        children: [
                          const Text(
                            'Payable (in months)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xFF667085,
                              ),
                            ),
                          ),
                          Text(
                            '${state.splitpayInfo!.nrOfMonths}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        space: 8,
                        children: [
                          Text(
                            formattedMonth,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xFF667085,
                              ),
                            ),
                          ),
                          Text(
                            formattedDay,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CheckboxWidget(
                            isChecked: false,
                            onChanged: (bool checked) {},
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Flexible(
                            child: Text(
                              'By selecting this tick box you are confirming the new SplitPay terms',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(
                                  0xFF414D63,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: PrimaryButton(
                      text: "Confirm and send",
                      onPressed: () {
                        showAlertDialog(
                          context: context,
                          message:
                              'Your split payment transaction was successful.',
                          onOkPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              HomeScreen.routeName,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
