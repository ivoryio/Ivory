import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/card_widget.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';




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
                  Text(
                    'Physical card successfully activated!',
                    style: ClientConfig.getTextStyleScheme().heading1,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'You can now start using your PIN to make in-store purchases, make withdrawals and more.',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IvoryAssetWithBadge(
                        childWidget: const BankCardWidget(
                          isCardEmpty: true,
                          customHeight: 148,
                          customWidth: 231,
                          isViewable: false,
                          imageScaledownFactor: 1.5,
                      ),
                        childPosition: BadgePosition.topEnd(
                          top: -32,
                          end: -32,
                        ),
                        isSuccess: true,
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
                      color:  ClientConfig.getColorScheme().tertiary,
                      textColor:  ClientConfig.getColorScheme().surface,
                      text: 'Back to "Card"',
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(HomeScreen.routeName),
                        );
                        StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(
                          user: user,
                          cardId: viewModel.bankCard!.id,
                        ));
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
