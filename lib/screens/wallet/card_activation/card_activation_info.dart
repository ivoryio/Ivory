import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/screens/wallet/card_activation/card_activation_choose_pin.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class BankCardDetailsInfoScreen extends StatelessWidget {
  static const routeName = '/cardDetailsInfoScreen';

  const BankCardDetailsInfoScreen({super.key});

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
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppToolbar(
                  richTextTitle: RichText(
                      text: TextSpan(
                    style: ClientConfig.getTextStyleScheme().heading4,
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Step 1 ',
                      ),
                      TextSpan(
                        text: 'out of 4',
                        style: TextStyle(color: ClientConfig.getCustomColors().neutral700),
                      ),
                    ],
                  )),
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  backButtonEnabled: true,
                  onBackButtonPressed: () {
                    Navigator.pop(context);
                    StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(
                      user: user,
                      cardId: viewModel.bankCard!.id,
                      forceReloadCardData: false,
                    ));
                  },
                ),
                LinearProgressIndicator(
                  value: 1 / 3,
                  color: ClientConfig.getColorScheme().secondary,
                  backgroundColor: ClientConfig.getCustomColors().neutral200,
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: Padding(
                    padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activate your physical card',
                          style: ClientConfig.getTextStyleScheme().heading2,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'In order to activate your physical card you will have to choose a PIN and confirm it. You can also add it to your Apple Wallet. \n\nIt\'ll take only 1 minute.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        ),
                        Expanded(
                          child: Center(
                            child: SvgPicture(
                              SvgAssetLoader(
                                'assets/images/choose_pin.svg',
                                colorMapper: IvoryColorMapper(
                                  baseColor: ClientConfig.getColorScheme().secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                            text: "Choose PIN",
                            disabledColor: ClientConfig.getCustomColors().neutral300,
                            color: ClientConfig.getColorScheme().tertiary,
                            textColor: ClientConfig.getColorScheme().surface,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                BankCardDetailsChoosePinScreen.routeName,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
