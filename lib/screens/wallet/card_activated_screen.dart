import 'package:flutter/cupertino.dart';
import '../../themes/default_theme.dart';
import '../../widgets/screen.dart';

class BankCardActivatedScreen extends StatelessWidget {
  const BankCardActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
      scrollPhysics: NeverScrollableScrollPhysics(),
      title: 'Card',
      centerTitle: true,
      hideBackButton: true,
      hideBottomNavbar: false,
      child: Padding(
        padding: defaultScreenPadding,
        child: Text(''),
      ),
    );
  }
}
