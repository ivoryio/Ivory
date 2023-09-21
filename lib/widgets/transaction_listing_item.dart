import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/screens/transactions/transaction_detail_screen.dart';

import '../config.dart';
import '../models/transactions/transaction_model.dart';
import '../models/transactions/upcoming_transaction_model.dart';
import '../utilities/format.dart';
import 'text_currency_value.dart';

const String defaultTransactionDescription = 'Transaction';
const String defaultTransactionRecipientName = 'Recipient name';

class TransactionListItem extends StatelessWidget {
  final bool isClickable;
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

    return InkWell(
      onTap: isClickable
          ? () => Navigator.pushNamed(context, TransactionDetailScreen.routeName, arguments: transaction)
          : null,
      child: TransactionCard(
        formattedDate: formattedDate,
        amount: amount,
        description: description,
        recipientName: recipientName,
        categoryIcon: transaction.category?.icon,
      ),
    );
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

    final DateFormat dateFormatter = DateFormat('MMM d, HH:mm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return InkWell(
      onTap: isClickable!
          ? () => Navigator.pushNamed(context, TransactionDetailScreen.routeName, arguments: upcomingTransaction)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  "assets/images/currency_exchange_euro.svg",
                  width: 20,
                  height: 20,
                  colorFilter: ColorFilter.mode(ClientConfig.getColorScheme().secondary, BlendMode.srcIn),
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Automatic repayment',
                    style: ClientConfig.getTextStyleScheme().heading4,
                  ),
                  Text(
                    formattedDate,
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                  )
                ]),
              ],
            ),
            Text(
              Format.amountWithSign(upcomingTransaction.outstandingAmount!),
              style: ClientConfig.getTextStyleScheme().heading4,
            )
          ],
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  recipientName.isNotEmpty ? recipientName : defaultTransactionRecipientName,
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
                Text(
                  formattedDate,
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular,
                )
              ]),
            ],
          ),
          TextCurrencyValue(
            digits: 0,
            value: amount,
            maxDigits: 2,
            style: ClientConfig.getTextStyleScheme().heading4,
          ),
        ],
      ),
    );
  }
}
