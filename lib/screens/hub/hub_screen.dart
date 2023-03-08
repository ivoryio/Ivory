import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HubScreen extends StatelessWidget {
  const HubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Center(child: Text('Hub')),
      ElevatedButton(
        onPressed: () => context.push('/home'),
        child: const Text('Go home'),
      ),
    ]);
  }
}
