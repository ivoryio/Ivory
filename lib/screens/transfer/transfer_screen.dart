import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routing_constants.dart';
import '../../widgets/person_home_header.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(child: Text('Search for a transfer')),
      ElevatedButton(
        onPressed: () => context.push(homePageRoutePath),
        child: const Text('Go home'),
      ),
      const PersonHomeHeader(),
    ]);
  }
}
