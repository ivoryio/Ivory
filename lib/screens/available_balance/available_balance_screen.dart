import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/gradient_progress_indicator.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../infrastructure/person/account_summary/account_summary_presenter.dart';
import '../../widgets/account_balance_text.dart';
import '../../widgets/modal.dart';
import '../../widgets/top_up_bottom_sheet_content.dart';

class AvailableBalanceScreen extends StatelessWidget {
  const AvailableBalanceScreen({Key? key}) : super(key: key);

  static const routeName = "/availableBalancePage";

  @override
  Widget build(BuildContext context) {
    final AccountSummaryFetchedViewModel viewModel = ModalRoute.of(context)!.settings.arguments as AccountSummaryFetchedViewModel ;

    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ClientConfig.getCustomClientUiSettings().defaultScreenTopPadding,),
            const AppToolbar(),
            Text(
              "Available balance",
              style: ClientConfig.getTextStyleScheme().heading1,
            ),
            const SizedBox(height: 16),
            Text(
              "You can transfer additional funds from your reference account to your Ivory account, enabling you to make purchases that exceed your credit limit.",
              style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
            ),
            const SizedBox(height: 16),
            InkWell(
              child: Text(
                "How to top up your Ivory account?",
                style:  ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                    color: ClientConfig.getColorScheme().secondary,
                ),
              ),
              onTap: () {
                showBottomModal(
                  context: context,
                  title: "How to top up your Ivory account?",
                  content: TopUpBottomSheetContent(iban: viewModel.accountSummary?.iban ?? ""),
                );
              },
            ),
            const SizedBox(height: 24,),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: ClientConfig.getCustomColors().neutral100,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full available balance",
                      style:  ClientConfig.getTextStyleScheme().labelSmall,
                    ),
                    const SizedBox(height: 4,),
                    AccountBalanceText(
                      value: viewModel.accountSummary?.availableBalance?.value ?? 0,
                      numberStyle: ClientConfig.getTextStyleScheme().heading2,
                      centsStyle: ClientConfig.getTextStyleScheme().heading3,
                    ),
                    const SizedBox(height: 8,),
                    GradientProgressIndicator(
                      percent: _percentageFromViewModel(viewModel),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: const Alignment(-0.9, 0),
                          stops: const [0.0, 0.5, 0.5, 1],
                          colors: [
                            ClientConfig.getCustomColors().neutral400,
                            ClientConfig.getCustomColors().neutral400,
                            ClientConfig.getColorScheme().primary,
                            ClientConfig.getColorScheme().primary,
                          ],
                        tileMode: TileMode.repeated,
                        ),
                      fillColor: ClientConfig.getColorScheme().secondary,
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      children: [
                        Column(
                          children: [
                            _colorBoxText("Credit", ClientConfig.getColorScheme().secondary, false),
                            const SizedBox(height: 4,),
                            Text(
                              "€${(viewModel.accountSummary!.availableBalance!.value! - viewModel.accountSummary!.balance!.value!)}",
                              style: ClientConfig.getTextStyleScheme().labelSmall,
                            ),
                          ],
                        ),
                        const SizedBox(width: 32,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _colorBoxText("Topped-up", null, true),
                            const SizedBox(height: 4,),
                            Text(
                              "€${viewModel.accountSummary!.balance!.value!}",
                              style: ClientConfig.getTextStyleScheme().labelSmall,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),],
        ),
      ),
    );
  }

  int _percentageFromViewModel(AccountSummaryFetchedViewModel viewModel) {
    num creditBalance = viewModel.accountSummary!.availableBalance!.value! - viewModel.accountSummary!.balance!.value!;
    if (creditBalance == 0) {
      return 100;
    }

    double percentage = (creditBalance / viewModel.accountSummary!.availableBalance!.value!) * 100;
    return percentage.round();
  }

  Widget _colorBoxText(String text, Color? color, bool useGradient) {
    LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: const Alignment(-0.5, 0),
      stops: const [0.0, 0.5, 0.5, 1],
      colors: [
        ClientConfig.getCustomColors().neutral400,
        ClientConfig.getCustomColors().neutral400,
        ClientConfig.getColorScheme().primary,
        ClientConfig.getColorScheme().primary,
      ],
      tileMode: TileMode.repeated,
    );

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: useGradient ? null : color,
            gradient: useGradient ? gradient : null,
          ),
        ),
        const SizedBox(width: 3,),
        Text(
          text,
          style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: ClientConfig.getCustomColors().neutral900),
        )
      ],
    );
  }
}
