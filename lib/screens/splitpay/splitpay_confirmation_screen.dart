import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../themes/default_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/checkbox.dart';
import '../../widgets/screen.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/transaction_listing_item.dart';

class SplitpayConfirmationScreen extends StatelessWidget {
  final Transaction transaction;

  const SplitpayConfirmationScreen({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Transaction confirmation',
      hideBottomNavbar: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: defaultScreenHorizontalPadding,
          right: defaultScreenHorizontalPadding,
          top: defaultScreenVerticalPadding,
          bottom: defaultScreenVerticalPadding + 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              space: 24,
              children: [
                const Text(
                  '€ 350.00 Mediamarkt purchase into monthly instalments from your limit of € 8000',
                  style: TextStyle(
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
                  children: const [
                    Text(
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
                      '€ 350',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 8,
                  children: const [
                    Text(
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
                      '9',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  space: 8,
                  children: const [
                    Text(
                      'APR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(
                          0xFF667085,
                        ),
                      ),
                    ),
                    Text(
                      '11',
                      style: TextStyle(
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
                      onChanged: (bool checked) {
                        // setState(() {
                        //   savePayee = checked;
                        // });
                      },
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
            SizedBox(
              width: double.infinity,
              height: 48,
              child: PrimaryButton(
                text: "Confirm and send",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
