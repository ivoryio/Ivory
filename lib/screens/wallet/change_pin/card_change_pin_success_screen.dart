import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../utilities/ivory_color_mapper.dart';

class BankCardChangePinSuccessScreen extends StatelessWidget {
  static const routeName = "/bankCardChangePinSuccessScreen";

  const BankCardChangePinSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;
    return StoreConnector<AppState, BankCardViewModel>(
      converter: (store) {
        return BankCardPresenter.presentBankCard(
          bankCardState: store.state.bankCardState,
          user: user,
        );
      },
      builder: (context, viewModel) {
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
                  child: Row(
                    children: [
                      IvoryAssetWithBadge(
                        childWidget: SvgPicture(
                          SvgAssetLoader(
                            'assets/images/choose_pin.svg',
                            colorMapper: IvoryColorMapper(
                              baseColor: ClientConfig.getColorScheme().secondary,
                            ),
                          ),
                        ),
                        childPosition: BadgePosition.topEnd(
                          top: -32,
                          end: -32,
                      ),
                        isSuccess: true,
                    ),
                    ],
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
                      StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(
                        user: user,
                        cardId: viewModel.bankCard!.id,
                        forceReloadCardData: true,
                      ));
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
