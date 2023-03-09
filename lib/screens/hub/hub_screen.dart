import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routing_constants.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(child: Text('Hub')),
      ElevatedButton(
        onPressed: () => context.push(homePageRoutePath),
        child: const Text('Go home'),
      ),
    ]);
  }
}
