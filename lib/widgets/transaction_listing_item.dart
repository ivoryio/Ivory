import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/screens/splitpay/splitpay_screen.dart';

import '../config.dart';
import '../models/transactions/transaction_model.dart';
import '../models/transactions/upcoming_transaction_model.dart';
import '../utilities/format.dart';
import 'button.dart';
import 'modal.dart';
import 'spaced_column.dart';
import 'text_currency_value.dart';

const String defaultTransactionDescription = 'Transaction';
const String defaultTransactionRecipientName = 'Recipient name';

class TransactionListItem extends StatelessWidget {
  final bool? isClickable;
  final Transaction transaction;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    var recipientName = removeUnrelatedWords(transaction.recipientName);

    final date = transaction.recordedAt!.toIso8601String();
    final description = transaction.description!;
    final amount = transaction.amount?.value ?? 0;

    final DateFormat dateFormatter = DateFormat('MMM d, HH:mm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return GestureDetector(
        onTap: () => isClickable!
            ? showBottomModal(
                isScrollControlled: true,
                context: context,
                title: 'Transaction Details',
                content: TransactionBottomPopup(
                  transaction: transaction,
                ),
              )
            : {},
        child: TransactionCard(
          formattedDate: formattedDate,
          amount: amount,
          description: description,
          recipientName: recipientName,
          categoryIcon: transaction.category?.icon,
        ));
  }

  removeUnrelatedWords(fullName) {
    var pattern = RegExp(r' X-');
    var storageResult = fullName!.split(pattern)[0];
    storageResult = storageResult.substring(0, shortenName(storageResult));

    return storageResult;
  }

  shortenName(name, {maxNameLength = 20}) {
    if (maxNameLength > name.length) {
      maxNameLength = name.length;
    }

    return maxNameLength;
  }
}

class UpcomingTransactionListItem extends StatelessWidget {
  final bool? isClickable;
  final UpcomingTransaction upcomingTransaction;

  const UpcomingTransactionListItem({
    super.key,
    required this.upcomingTransaction,
    this.isClickable = true,
  });

  @override
  Widget build(BuildContext context) {
    final date = upcomingTransaction.statementDate!.toIso8601String();
    final amount = upcomingTransaction.outstandingAmount?.value ?? 0;

    final DateFormat dateFormatter = DateFormat('MMM d, HH:mm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.currency_exchange,
                size: 20,
                color: ClientConfig.getColorScheme().secondary,
              ),
              const SizedBox(
                width: 16,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Automatic repayment',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                  ),
                )
              ]),
            ],
          ),
          Text(
            amount == 0
                ? Format.euro(amount)
                : amount < 0
                    ? (Format.euro(amount)).split(' ').join('')
                    : '+ ${Format.euro(amount).split(' ').join('')}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  removeSpaceBetweenCurrencyAndAmount(amount) {
    var pattern = RegExp(r' ');

    var storageResult = amount!.split(pattern);
    storageResult = storageResult.join('');

    return storageResult;
  }
}

class TransactionCard extends StatelessWidget {
  final String recipientName;
  final String description;
  final double amount;
  final String formattedDate;
  final IconData? categoryIcon;

  const TransactionCard({
    super.key,
    required this.description,
    required this.recipientName,
    required this.formattedDate,
    required this.amount,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                categoryIcon,
                size: 20,
                color: ClientConfig.getColorScheme().secondary,
              ),
              const SizedBox(
                width: 16,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                    recipientName.isNotEmpty
                        ? recipientName
                        : defaultTransactionRecipientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    )),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Color(0xFF667085),
                  ),
                )
              ]),
            ],
          ),
          TextCurrencyValue(
              digits: 0,
              value: amount,
              maxDigits: 2,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              )),
        ],
      ),
    );
  }
}

class TransactionBottomPopup extends StatelessWidget {
  final Transaction transaction;

  const TransactionBottomPopup({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy, HH:Hm ');
    final String formattedDate = dateFormatter
        .format(DateTime.parse(transaction.recordedAt!.toIso8601String()));

    return Column(
      children: [
        SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          space: 8,
          children: [
            const Text(
              'Source account IBAN:',
              style: TextStyle(
                color: Color(
                  0xFF667085,
                ),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                Text(
                  transaction.recipientIban!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: const Divider(
            color: Color(0xFFEEEEEE),
            thickness: 1,
          ),
        ),
        SpacedColumn(
          space: 24,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Statement',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.download,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  _formatAmountWithCurrency(transaction.amount!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Card',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'VISA ••5199',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.fastfood,
                      size: 19,
                    ),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      'Restaurants',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exclude from analytics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                PlatformSwitch(
                  value: false,
                  onChanged: (bool value) {},
                )
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: const Divider(
            color: Color(0xFFEEEEEE),
            thickness: 1,
          ),
        ),
        SpacedColumn(
          space: 32,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      'Download',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: PrimaryButton(
                text: "Convert into instalments",
                onPressed: () {
                  Navigator.popAndPushNamed(
                    context,
                    SplitpayScreen.routeName,
                    arguments: SplitpayScreenParams(transaction: transaction),
                  );
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag,
                ),
                SizedBox(
                  width: 24,
                ),
                Text(
                  'Report this transaction',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ],
        )
      ],
    );
  }

  String _formatAmountWithCurrency(Amount amount) {
    double value = amount.value!;
    String currencySymbolt = Format.getCurrencySymbol(amount.currency!);

    String formattedAmount = value.abs().toStringAsFixed(2);
    String sign = value < 0 ? '-' : '+';

    return '$sign $currencySymbolt $formattedAmount';
  }
}
