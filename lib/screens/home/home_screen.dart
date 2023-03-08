import 'package:flutter/material.dart';
import 'package:solaris_structure_1/widgets/button_centered.dart';
import 'package:solaris_structure_1/widgets/text_currency_value.dart';
import 'package:solaris_structure_1/widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text("Accounts")),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                    onPressed: () {}, child: const Text("Cards")),
              ),
            ],
          ),
          Card(
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      const HomeAccountBalance(
                        balance: 5,
                      ),
                      const HomeTransactionListHeader(),
                      const TransactionList(),
                      ButtonCentered(action: () {}, label: "See all")
                    ],
                  )))
        ],
      ),
    );
  }
}

class HomeAccountBalance extends StatelessWidget {
  final double balance;

  const HomeAccountBalance({super.key, this.balance = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Balance: ",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          TextCurrencyValue(
            value: 15,
            style: TextStyle(fontSize: 18),
          ),
        ]),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Add money"),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeTransactionListHeader extends StatelessWidget {
  const HomeTransactionListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Transactions", style: TextStyle(fontSize: 16)),
          ElevatedButton(
            onPressed: () {},
            child: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
