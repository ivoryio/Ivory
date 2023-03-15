import 'package:flutter/material.dart';

import '../../widgets/screen.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: "Transactions",
      child: Center(
        child: Text('Transactions'),
      ),
    );
  }
}
