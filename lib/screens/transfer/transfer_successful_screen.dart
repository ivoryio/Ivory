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
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../utilities/ivory_color_mapper.dart';

class TransferSuccessfulScreenParams {
  final double amount;
  final String fromAccount;
  final String toAccount;

  const TransferSuccessfulScreenParams({
    required this.amount,
    required this.fromAccount,
    required this.toAccount,
  });
}

class TransferSuccessfulScreen extends StatelessWidget {
  static const routeName = "/transferSuccessfulScreen";

  const TransferSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final regularFont = ClientConfig.getTextStyleScheme().bodyLargeRegular;
    final boldFont = ClientConfig.getTextStyleScheme().bodyLargeRegularBold;

    return ScreenScaffold(
      shouldPop: false,
      body: Column(
        children: [
          Expanded(
            child: ScrollableScreenContainer(
              child: Padding(
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Transfer successful",
                        style: ClientConfig.getTextStyleScheme().heading1,
                        textAlign: TextAlign.left,
                      ),
                    ),
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
                                style: regularFont,
                                children: [
                                  TextSpan(
                                    text: Format.euro(viewModel.amount, digits: 2),
                                    style: boldFont,
                                  ),
                                  TextSpan(
                                    text: " from your ",
                                    style: regularFont,
                                  ),
                                  TextSpan(text: "Reference account", style: boldFont),
                                  TextSpan(text: " to your ", style: regularFont),
                                  TextSpan(text: "Ivory account", style: boldFont),
                                  TextSpan(
                                    text: ".",
                                    style: regularFont,
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
                        style: regularFont,
                        children: [
                          TextSpan(
                            text: "Transactions ",
                            style: boldFont.copyWith(color: ClientConfig.getColorScheme().secondary),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    TransactionsScreen.routeName,
                                    (route) => false,
                                  ),
                            children: [
                              TextSpan(
                                text: "section.",
                                style: regularFont,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(child: SvgPicture(
                      SvgAssetLoader(
                        'assets/images/repayment_more_credit.svg',
                        colorMapper: IvoryColorMapper(
                          baseColor: ClientConfig.getColorScheme().secondary,
                        ),
                      ),
                    ),),
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
