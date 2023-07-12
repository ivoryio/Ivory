import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/card_details_cubit/card_details_cubit.dart';
import '../../themes/default_theme.dart';
import '../../widgets/screen.dart';

class BankCardActivatedScreen extends StatelessWidget {
  const BankCardActivatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<BankCardDetailsCubit>().state;

    return const Screen(
      scrollPhysics: const NeverScrollableScrollPhysics(),
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
