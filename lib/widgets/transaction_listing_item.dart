import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/popup_header.dart';

import '../models/transaction_model.dart';
import 'text_currency_value.dart';

const String defaultTransactionDescription = 'Transaction';

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
        onTap: () => showBottomModal(
              context: context,
              child: TransactionBottomPopup(
                transaction: transaction,
              ),
            ),
        child: TransactionCard(
          amount: amount,
          description: description,
          formattedDate: formattedDate,
        ));
  }
}

class TransactionCard extends StatelessWidget {
  final String description;
  final String formattedDate;
  final double amount;

  const TransactionCard({
    super.key,
    required this.description,
    required this.formattedDate,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                                : defaultTransactionDescription,
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
                maxDigits: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )),
          ],
        ),
      ),
    );
  }
}

class TransactionBottomPopup extends StatelessWidget {
  final Transaction transaction;

  const TransactionBottomPopup({super.key, required this.transaction});

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
                  TextCurrencyValue(
                    digits: 2,
                    value: transaction.amount?.value ?? 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
