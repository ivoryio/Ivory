import 'package:badges/badges.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/screens/transactions/transactions_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';



class TopUpSuccessfulScreen extends StatelessWidget {
  static const routeName = "/topUpSuccessfulScreen";

  const TopUpSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenScaffold(
      shouldPop: false,
      body: Column(
        children: [
          AppToolbar(
            backButtonEnabled: false,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          Expanded(
            child: ScrollableScreenContainer(
              child: Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ScreenTitle("Money successfully added"),
                    const SizedBox(height: 16),
                    StoreConnector<AppState, TransferViewModel>(
                      converter: (store) => TransferPresenter.presentTransfer(
                        transferState: store.state.transferState,
                        personAccountState: store.state.personAccountState,
                        referenceAccountState: store.state.referenceAccountState,
                      ),
                      builder: (context, viewModel) => viewModel is TransferConfirmedViewModel
                          ? RichText(
                              text: TextSpan(
                                text: "You have successfully transferred ",
                                style: TextStyle(color: ClientConfig.getCustomColors().neutral900),
                                children: [
                                  TextSpan(
                                    text: Format.euro(viewModel.amount, digits: 2),
                                    style: TextStyle(color: ClientConfig.getCustomColors().neutral900),
                                  ),
                                  TextSpan(
                                    text: "to your Iulius bank account.",
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        text: "Your can review the transfer in the ",
                        style: TextStyle(color: ClientConfig.getCustomColors().neutral900),
                        children: [
                          TextSpan(
                            text: "Transactions ",
                            style: TextStyle(color: ClientConfig.getColorScheme().secondary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    TransactionsScreen.routeName,
                                    (route) => false,
                                  ),
                            children: [
                              TextSpan(
                                text: "section.",
                                style: TextStyle(color: ClientConfig.getCustomColors().neutral900),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    IvoryAssetWithBadge(
                      isSuccess: true,
                      childPosition: BadgePosition.topEnd(top: -32, end: -32),
                      childWidget: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/transfer_successful_illustration.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Button(
              color: ClientConfig.getColorScheme().tertiary,
              text: "Back to \"Home\"",
              textColor: ClientConfig.getColorScheme().surface,
              onPressed: () => Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
