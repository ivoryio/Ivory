import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/screens/transactions/transaction_detail_screen.dart';
import 'package:solarisdemo/widgets/skeleton.dart';

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
    var recipientName = removeUnrelatedWords(transaction.recipientName ?? 'recipient name');

    final date = transaction.recordedAt!.toIso8601String();
    final description = transaction.description ?? 'description';
    final amount = transaction.amount?.value ?? 0;

    final DateFormat dateFormatter = DateFormat('MMM d, HH:mm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return InkWell(
      onTap: isClickable
          ? () => Navigator.pushNamed(context, TransactionDetailScreen.routeName, arguments: transaction)
          : null,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: TransactionCard(
          formattedDate: formattedDate,
          amount: amount,
          description: description,
          recipientName: recipientName,
          categoryIcon: transaction.category?.icon,
        ),
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

  static Widget loadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Skeleton(height: 24, width: 24, borderRadius: BorderRadius.circular(100)),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Skeleton(height: 16, width: 128),
                    Spacer(),
                    Skeleton(height: 16, width: 64),
                  ],
                ),
                SizedBox(height: 8),
                Skeleton(height: 10, width: 64),
              ],
            ),
          ),
        ],
      ),
    );
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
        child: Padding(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
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
                getRandomMerchantIcon(),
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

  IconData getRandomMerchantIcon() {
    List<IconData> icons = [
      Icons.local_taxi_outlined,
      Icons.fastfood_outlined,
      Icons.shopping_bag_outlined,
      Icons.local_gas_station_outlined,
      Icons.health_and_safety_outlined,
      Icons.devices_outlined,
      Icons.live_tv_outlined,
      Icons.house_outlined,
      Icons.receipt_long_outlined,
      Icons.school_outlined,
      Icons.account_balance_outlined,
      Icons.local_offer_outlined,
      Icons.currency_exchange,
      Icons.euro,
    ];

    return icons[Random().nextInt(icons.length)];
  }
}
