import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/screens/wallet/cards_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../infrastructure/bank_card/bank_card_presenter.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';

class BankCardDetailsActivationSuccessScreen extends StatelessWidget {
  static const routeName = '/bankCardDetailsActivationSuccessScreen';

  const BankCardDetailsActivationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, BankCardViewModel>(
        converter: (store) => BankCardPresenter.presentBankCard(
              bankCardState: store.state.bankCardState,
              user: user,
            ),
        builder: (context, viewModel) {
          return ScreenScaffold(
            body: Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppToolbar(
                    backButtonEnabled: false,
                  ),
                  const Text(
                    'Physical card successfully activated!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You can now start using your PIN to make in-store purchases, make withdrawals and more.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                  const Spacer(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BankCardWidget(
                        isCardEmpty: true,
                        customHeight: 148,
                        customWidth: 231,
                        isViewable: false,
                        imageScaledownFactor: 1.5,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 124,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      disabledColor: const Color(0xFFDFE2E6),
                      color: const Color(0xFF2575FC),
                      text: 'Back to "Card"',
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(BankCardsScreen.routeName),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
