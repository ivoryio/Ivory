import 'package:flutter/cupertino.dart';

import '../../config.dart';
import '../../widgets/screen.dart';

class BankCardActivatedScreen extends StatelessWidget {
  static const routeName = '/bankCardActivatedScreen';

  const BankCardActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      title: 'Card',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: true,
      child: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: const Text('ACTIVEEEEEEEEEEEE'),
      ),
    );
  }
}
