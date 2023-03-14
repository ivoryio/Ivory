import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../widgets/text_currency_value.dart';
import '../../widgets/transaction_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              elevation: 10,
              child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Column(
                    children: const [
                      HomeAccountBalance(
                        balance: 5,
                      ),
                      TransactionList()
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
            PlatformElevatedButton(
              onPressed: () {},
              cupertino: (context, platform) => CupertinoElevatedButtonData(
                borderRadius: const BorderRadius.all(Radius.circular(7)),
              ),
              child: Row(children: const [
                Icon(Icons.add),
                Text("Add money"),
              ]),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Transactions", style: TextStyle(fontSize: 16)),
        ElevatedButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        )
      ],
    );
  }
}
