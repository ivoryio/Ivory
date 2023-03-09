import 'package:flutter/material.dart';
import 'package:solaris_structure_1/models/transaction.dart';
import 'package:solaris_structure_1/services/transaction_service.dart';
import 'package:solaris_structure_1/widgets/transaction_listing_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TransactionService().getTransactions(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const Text("Transactions could not be loaded");
        }

        if (snapshot.hasData) {
          var transactions = snapshot.data as List<Transaction>;

          if (transactions.isEmpty) {
            return const Text("No transactions found");
          }

          return ListView.builder(
              itemCount: transactions.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return TransactionListItem(
                  vendor: transactions[index].recipientName ?? "Unknown Vendor",
                  date: transactions[index].bookingDate ?? "Unknown Date",
                  amount: transactions[index].amount?.value ?? 0.0,
                );
              });
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class MyWidget<T> extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  factory MyWidget.builder() {
    return const MyWidget();
  }
}
