import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(child: Text('Search for a transfer')),
      ElevatedButton(
        onPressed: () => context.push('/home'),
        child: const Text('Go home'),
      ),
    ]);
  }
}
