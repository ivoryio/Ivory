import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/widgets/popup_header.dart';

import '../models/transaction_model.dart';
import 'text_currency_value.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final date = transaction.bookingDate!;
    final description = transaction.description!;
    final amount = transaction.amount?.value ?? 0;

    final DateFormat dateFormatter = DateFormat('d MMMM, HH:Hm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return GestureDetector(
      onTap: () => showPlatformModalSheet(
        context: context,
        builder: (_) => TransactionPopup(
          transaction: transaction,
        ),
      ),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.80),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.add_card, size: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              description.isNotEmpty
                                  ? description
                                  : 'Transaction',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              )),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              color: Color(0xFF667085),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              TextCurrencyValue(
                  digits: 0,
                  value: amount,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionPopup extends StatelessWidget {
  final Transaction transaction;

  const TransactionPopup({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BottomPopupHeader(title: "Transaction Details"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("Transaction ID"),
                  Text(transaction.id!),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("Booking Date"),
                  Text(transaction.bookingDate!),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  const Text("Amount"),
                  TextCurrencyValue(value: transaction.amount?.value ?? 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
