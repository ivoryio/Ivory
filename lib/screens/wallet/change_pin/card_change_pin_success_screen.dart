import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardChangePinSuccessScreen extends StatelessWidget {
  static const routeName = "/bankCardChangePinSuccessScreen";

  const BankCardChangePinSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(
              backButtonEnabled: false,
            ),
            Text(
              'PIN successfully\nchanged!',
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text(
              'You’ve successfully reset your PIN.',
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/choose_pin.svg',
                      ),
                      Positioned(
                        left: 217,
                        bottom: 197,
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00774C)),
                          child: Icon(
                            Icons.check,
                            color: ClientConfig.getColorScheme().surface,
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Button(
                disabledColor: const Color(0xFFDFE2E6),
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
                text: 'Back to "Card"',
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(HomeScreen.routeName),
                  );
                  StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(user: user, cardId: 'cardID'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
