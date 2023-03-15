import 'package:flutter/material.dart';

import '../../widgets/screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      title: "Wallet",
      child: Center(
        child: Text('Wallet'),
      ),
    );
  }
}
