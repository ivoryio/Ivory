import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../router/routing_constants.dart';
import 'modal.dart';
import 'button.dart';
import 'popup_header.dart';
import 'spaced_column.dart';
import 'text_currency_value.dart';
import '../utilities/format.dart';
import '../models/transaction_model.dart';

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
    final date = transaction.bookingDate!;
    final recipientName =
        transaction.recipientName ?? defaultTransactionRecipientName;
    final description = transaction.description!;
    final amount = transaction.amount?.value ?? 0;

    final DateFormat dateFormatter = DateFormat('d MMMM, HH:Hm ');
    final String formattedDate = dateFormatter.format(DateTime.parse(date));

    return GestureDetector(
        onTap: () => isClickable!
            ? showBottomModal(
                context: context,
                child: TransactionBottomPopup(
                  transaction: transaction,
                ),
              )
            : {},
        child: TransactionCard(
          formattedDate: formattedDate,
          amount: amount,
          description: description,
          recipientName: recipientName,
        ));
  }
}

class TransactionCard extends StatelessWidget {
  final String recipientName;
  final String description;
  final double amount;
  final String formattedDate;

  const TransactionCard({
    super.key,
    required this.description,
    required this.recipientName,
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
                            recipientName.isNotEmpty
                                ? recipientName
                                : defaultTransactionRecipientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        Text(
                          description.isNotEmpty
                              ? description
                              : defaultTransactionDescription,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                          ),
                        )
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
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy, HH:Hm ');
    final String formattedDate =
        dateFormatter.format(DateTime.parse(transaction.bookingDate!));

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
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
          const BottomPopupHeader(
            title: "Transaction Details",
            customPaddingEdgeInsets: EdgeInsets.symmetric(
              vertical: 24,
              horizontal: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32,
              left: 24,
              right: 24,
            ),
            child: Column(
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
                          context.push(
                            splitpaySelectRoute.path,
                            extra: transaction,
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
            ),
          ),
        ],
      ),
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
